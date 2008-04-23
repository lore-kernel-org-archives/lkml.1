Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYDWVr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYDWVr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYDWVro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:47:44 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:10362 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbYDWVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qnR1OgXcMC43/PLQ/hHXgxIZ0MOJgp3VyVe8ZYqonDgtykdZC84cFIeY+ss18SN+bmwM8wwsnfAICizmzsNXLv8DDArxYczYCGlZ/b72TBXe5HMtJgTLJJ586aaR7BeIuAo56XT/YjmDnWTMbwdT2teVHMKO3PuEtmH3LsZsqC8=
Message-ID: <86802c440804231447x4e809c0cl5ca995db79e6075d@mail.gmail.com>
Date: Wed, 23 Apr 2008 14:47:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mark Salyzyn" <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] aacraid: Fix down_interruptible() to check the return value take 2 (was: aacraid broken in git)
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
	 <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
	 <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com>
	 <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 5:16 AM, Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:
> On Apr 21, 2008, at 8:42 PM, Yinghai Lu wrote:
>
>
> > bisected to:
> >
> > yhlu@mpk12-office-77-185:~/xx/xx/kernel/linux-2.6> git-bisect good
> > e6990c6448ca9359b6d4ad027c0a6efbf4379e64 is first bad commit
> > commit e6990c6448ca9359b6d4ad027c0a6efbf4379e64
> > Author: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
> > Date:   Mon Apr 14 14:20:16 2008 -0400
> >
> >   [SCSI] aacraid: Fix down_interruptible() to check the return value
> >
> >   Instead of ignoring the return value in aac_fib_send() return 2 to
> >   indicate to the layers above that fib transmission was aborted due to
> >   timeout.
> >
> >   Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> >   Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >
> > :040000 040000 2f23bf33d76d6f37c558251003f88537c6e639fe
> > 63d59091ca7ac527b5106540eea06d7b6649862d M      drivers
> >
>
>
>  The return value for down_interruptible was incorrectly checked! updated
> patch enclosed.
>
>  This attached patch is against current scsi-misc-2.6 (minus original
> down_interruptible patch).
>
>  ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patch attachments (inline gets damaged, please use attachment).
>
>  Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>
>   drivers/scsi/aacraid/commsup.c |    8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
>  diff -ru a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
>  --- a/drivers/scsi/aacraid/commsup.c    2008-04-14 14:08:00.737201138 -0400
>  +++ b/drivers/scsi/aacraid/commsup.c    2008-04-14 14:09:34.019252960 -0400
>  @@ -515,10 +515,12 @@
>                                 }
>                                 udelay(5);
>                         }
>  -               } else
>  -                       (void)down_interruptible(&fibptr->event_wait);
>  +               } else if (down_interruptible(&fibptr->event_wait)) {
>  +                       fibptr->done = 2;
>  +                       up(&fibptr->event_wait);
>  +               }
>                 spin_lock_irqsave(&fibptr->event_lock, flags);
>  -               if (fibptr->done == 0) {
>  +               if ((fibptr->done == 0) || (fibptr->done == 2)) {
>                         fibptr->done = 2; /* Tell interrupt we aborted */
>                         spin_unlock_irqrestore(&fibptr->event_lock, flags);
>                         return -EINTR;
>

it works.

Thanks

YH
