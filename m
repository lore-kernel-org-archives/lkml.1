Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0BEIbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:31:52 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:40893 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0BEIbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:31:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hmFKiv+JDULw6IChaoo/h8oRI/SwRFJifUIHa2KncHkdETggYIJaeCr8GrUIsDxiD4
         iFJX1FFaPFkS3fXpcxxTLjy2EImnlUq6OJN39LygTurwEHJR+PEiOcytJxCto7nq1bhh
         JM9VJ/A7t6m6vruLN+kc3qXGg16Ic9Pqz17Fk=
Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
 unsafe resume was enabled
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100204160957.1c51cc1b.akpm@linux-foundation.org>
References: <1265219241.12549.8.camel@maxim-laptop>
	 <1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
	 <20100204160957.1c51cc1b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 10:31:42 +0200
Message-ID: <1265358702.3424.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 16:09 -0800, Andrew Morton wrote: 
> On Fri,  5 Feb 2010 01:18:15 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > Currently removal of the card leads to del_disk called indirectly by mmc core.
> > This function expects userspace to be running, which isn't when .resume is called
> > 
> > Fix that by removing the code that did that in mmc_resume_host. It is possible
> > because card detection logic will kick it later and remove the card.
> 
> I don't really understand.  The above implies that to trigger this bug,
> one needs to physically remove the card during a resume operation.  ie:
> a human-vs-computer race.  Sounds unlikely?
> 
> So...  exactly what steps does the user need to take to trigger this

Sorry for describing this poorly.
The steps are:

-> Have a kernel with CONFIG_MMC_UNSAFE_RESUME
-> Insert MMC/SD card
-> Suspend/hibernate the system
-> While system is hibernated/suspended pull the card off
-> Resume the system
-> Hang


if CONFIG_MMC_UNSAFE_RESUME is set, mmc core allows the user to
suspend/resume the card normally assuming he won't change the card or
modify it in another system. The former case is actually handled quite
well.

if CONFIG_MMC_UNSAFE_RESUME isn't set, it removes the card during
suspend, and I now think (and will test) that this will still hang the
system this time on suspend.

Maybe we can make del_disk behave well if called with userspace frozen?
After all if user calls it, very likely that hardware is absent thus
there is no point in syncing (which I think triggers the hang)....

Best regards,
Maxim Levitsky

