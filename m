Return-Path: <linux-kernel-owner+w=401wt.eu-S1763253AbZFOQCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763253AbZFOQCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbZFOQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:02:35 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:56443 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZFOQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:02:34 -0400
Message-ID: <4A367093.6010206@linux.vnet.ibm.com>
Date: Mon, 15 Jun 2009 13:02:27 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090614)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: =?UTF-8?B?ImRkcyAo4piVKSI=?= <dds@google.com>, seiji.munetoh@gmail.com,
       tpmdd-devel@lists.sourceforge.net,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shahbaz Khan <shaz.linux@gmail.com>
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module
 for 2.6.30
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com> <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com> <4A3474BD.4000804@linux.vnet.ibm.com> <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com> <1245007238.10712.5.camel@blackbox> <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>
In-Reply-To: <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Sun, 2009-06-14 at 16:20 -0300, Rajiv Andrade wrote:
>   
>> Hi David,
>>
>> On Sun, 2009-06-14 at 16:15 +0900, dds (☕) wrote:
>>     
>>> Hello, I'd been meaning to write about this.
>>>       
>
> I can't seem to find the mail from david in any archive, does anyone
> have a pointer?
>
>   
Neither do I, only have it in my inbox, seems that it got bounced by
both ML..
> but my real problem is that the patch doesn't work!  We call tpm_getcap
> to know if we should work around a tpm bug.
>
> tpm_getcap->transmit_cmd->tpm_transmit->chip->vendor.send
>
> which of course ends up in tpm_tis_send() but we needed that
> manufacturer_id before tpm_tis_send can work!
>
>   
Yep, sorry. Two options:

1- Inside that check, if got an error when in that particular
tpm_getcap() stacked call, consider that it might be this iTPM, and
bypass it just to get the value from the chip (would happen only once) -
Would work, but it's odd.

2- Forget manufacturer_id and base the decision on the PNP_ID as david
suggested. I previously considered it but since it would end up in
modifying tpm_tis_init() prototype (struct device * to struct pnp_dev *)
and then wouldn't work when loading as a module with force option on, so
I moved to the manufacturer_id approach.

I'll get back to #2 meanwhile and post the patch, seems not hard to
accomplish though..
> Below is my dmesg output of a failed build.
>
> [root@dhcp231-142 ~]# dmesg | grep -i tpm
> [    0.945438] Platform driver 'tpm_tis' needs updating - please use dev_pm_ops
> [    0.951161] tpm_tis tpm_tis: 1.2 TPM (device-id 0x1020, rev-id 6)
> [    0.957171] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
> [    0.963239] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
> [    0.969190] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
> [    0.975165] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
> [    0.975369] tpm_tis_init: chip->manufacturer_id=0
> [    1.097287] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
> [    1.097445] No TPM chip found, activating TPM-bypass!
> [  110.859305] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
>
> See all the failed tpm calls before we set the manufacturer_id at time
> 0.975369?  (that printk is my own addition in tpm_tis_init)
>
> But at least you know the manucaturer_id if it helps...
>
>   
For now it does, thanks

Rajiv
