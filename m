Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYIJW6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYIJW6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYIJW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:58:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:38358 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYIJW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uBBXfNwS2LVaeKBGpnEwc7YDxoZIk1FKGI1Tw1n354y+fnWd1UTSa4iewYdgvAdDtZ
         dGUXXwiR+MT9bcfilBmIlIGiNbt/GPRAHXOtQiVlxJCfQxet0jBgB/KBnOOjk2zfSykL
         DUAVLtJXiKqqYdV7MlM20k3BllgIEl6hHtwcQ=
Message-ID: <48C850AA.2030409@gmail.com>
Date: Thu, 11 Sep 2008 00:56:42 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>	<48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local>	<48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local>	<48C82CB1.2070308@gmail.com> <871vzrogpz.fsf@denkblock.local>
In-Reply-To: <871vzrogpz.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
>>> Should I change ata_eh_about_to_do() so that it will record the action
>>> in link->eh_context before clearing it in link->eh_info?
>> That's what ata_eh_about_to_do() currently does, exactly.  Actually,
>> that's the whole reason it's there as the described problem exists for
>> all other actions too.  :-)
> 
> Sounds reasonable enough. Much as I regret it, though, I really can't
> find that this is what actually happens. Where exactly is the action
> propagated from ehi to ehc->i? (Checked next-20080903, v2.6.27-rc5 and
> v2.6.26).

Oops, that was me being stupid.  I can't find it either.  Right, it's
never pulled in as for all other actions, it's enough to make sure
that EH is repeated if an action gets scheduled after
ata_eh_about_to_do().  Sorry about the confusion.  Can you please use
the following function before ata_eh_about_to_do()?

static void ata_eh_pull_action(struct ata_link *link, struct ata_device
*dev,
			       unsigned int action)
{
	...
	struct ata_eh_info *ehi = &link->eh_info;
	struct ata_eh_context *ehc = &link->eh_context;
	...

	spin_lock_irqsave(ap->lock, flags);

	if (dev)
		ehc->i.dev_action[dev->devno] |=
			ehi->dev_action[dev->devno] & action;
	ehc->i.action |= ehi->action & action;

	spin_unlock_irqrestore(ap->lock, flags);
}

And add comment explaning why the operation is needed for unload
action?

> On another matter: I don't particularly like the idea that there should
> appear an "EH complete" in the logs every time a head unload request has
> been processed. Is it safe to set ATA_EHI_QUIET when scheduling unload
> requests or is the risk that something important may be missed too high?

Hmmm... ATA_EHI_QUIET masks all EH reporting and as error conditions
are not unlikely under physical shocks, I don't think suppressing them
all is a good idea.  How about adding ATA_EH_QUIET_MASK or a boolean
parameter to ata_eh_about_to_do() such that unload action doesn't set
RECOVERED flag?

Thanks.  :-)

-- 
tejun
