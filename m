Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbYI1P2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbYI1P2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYI1P2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:28:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:18838 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYI1P2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=fraXwTOF/iwCPly44l+Ssk1fO/LBPzVG7K9xFCF7i9l03Vbs5GlOXHpSW7Y/UUAh6S
         Ew3dmm9+KpDblg+U4BuL+gQ3gvllvV79lB8xWU4+1G0je2OhYSuZy5DGTqiHHSK23eHZ
         kHCer79obQlwa/2uMDkLmyaYhe0uSuVA52q+4=
Message-ID: <48DFA285.1010701@panasas.com>
Date: Sun, 28 Sep 2008 18:28:05 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       jens.axboe@oracle.com
Subject: Re: scatterlist.c: bug in sg_next()?
References: <c384c5ea0809280815l63fab13fqf97a619598f0dd71@mail.gmail.com>
In-Reply-To: <c384c5ea0809280815l63fab13fqf97a619598f0dd71@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> Hello,
> 
> I was code-inspecting 2.6.27-r7 through git web, when I came across this:
> 
> In sg_next(), after following a chain_ptr, a few more checks should be
> performed.
> The rare case exists that the first entry in the chained list is a
> last marker, in case NULL must be returned.
> 
> Can someone confirm and cook a patch?
> 
> struct scatterlist *sg_next(struct scatterlist *sg)
> {
>   if (sg_is_last(sg))
>     return NULL;
>   sg++;
>   if (unlikely(sg_is_chain(sg))) {
>      sg = sg_chain_ptr(sg);
> +#ifdef CONFIG_DEBUG_SG
> + BUG_ON(sg->sg_magic != SG_MAGIC);
> +#endif
> +   if (sg_is_last(sg))
> +     return NULL;
>   }
>   return sg;
> }
> 
> Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
> 
> Regards,

No! the last marker is set on a valid sg entry. Only it's next
is no longer valid. So the check at the top is for the Next-sg
not the passed-in-sg. What you thought of is a NULL terminating
sg-list. The end marker is so to save the extra NULL entry.

Boaz

