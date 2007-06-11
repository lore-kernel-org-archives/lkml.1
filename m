Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXFKLSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXFKLSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXFKLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:18:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:43460 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXFKLSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=klZIGvb9+J4u2wMuk5kdNr798Hngj+KaR59x7iSqCqpPmmMS7o9nNDIQn1iL06X3c1ahewsMpNo0D/1A3++Z9a+RigUQVd9YMdAzOx4d1WOAlB4MtBeyazy9zkMD4E1qNRagM8VsDskeborwKecy6q70HRziH7NmDj1YGKpNbas=
Message-ID: <9a8748490706110418m70d4b26ege20a51f04b8ff7ff@mail.gmail.com>
Date: Mon, 11 Jun 2007 13:18:21 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: Surya <surya.prabhakar@wipro.com>
Subject: Re: [PATCH]: complete cleanup of check_region
Cc: emoenke@gwdg.de, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       kernel-janitors@lists.osdl.org
In-Reply-To: <1181270772.3275.15.camel@bluegenie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181209169.2422.12.camel@bluegenie>
	 <9a8748490706070308m7c2212fq30fe712e26e2463b@mail.gmail.com>
	 <1181215018.3275.2.camel@bluegenie>
	 <9a8748490706070902i218e01bdq1c418c770e99ca4@mail.gmail.com>
	 <1181270772.3275.15.camel@bluegenie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/07, Surya <surya.prabhakar@wipro.com> wrote:
<snip>
> > >                 msg(DBG_INI,"check_drives done.\n");
> > > +               if(request_region_flag==0)
> > > +                       release_region(addr[1],4);
> >
> > I know the driver in its current version just tests if the region is
> > available and doesn't hang on to it, but I'm wondering if that's not a
> > bug.  Shouldn't we actually hold on to this region as long as the
> > driver is loaded and only release the region in the sbpcd_exit()
> > function, just loke we do with the "CDo_command" region?
> But if any of the conditions fail after the request_region code, it is
> returning an error and exiting out of init. Dont we need to cleanup
> request_region's allocation before we exit.

Probably.

> Infact I had a feeling that
> CDo_command region cleanup was not perfect. Did a cleanup of both the
> regions wherever we have a return out of the function.
>
That makes sense to me.

> Please have a look at the below patch.
>
>
> diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
> index a1283b1..0a85b1b 100644
> --- a/drivers/cdrom/sbpcd.c
> +++ b/drivers/cdrom/sbpcd.c
> @@ -358,6 +358,10 @@
>   * Add bio/kdev_t changes for 2.5.x required to make it work again.
>   * Still room for improvement in the request handling here if anyone
>   * actually cares.  Bring your own chainsaw.    Paul G.  02/2002
> + *
> + *

Why two blank comment lines?  Isn't one enough?

> + * Cleaned up the reference for deprecated check_region to
> + * request_region.            - Surya Prabhakar N      08/07/2007
>   */
>
>
> @@ -555,6 +559,8 @@ static struct cdrom_read_audio read_audio;
>  static unsigned char msgnum;
>  static char msgbuf[80];
>
> +static int addr[2];
> +
>  static int max_drives = MAX_DRIVES;
>  module_param(max_drives, int, 0);
>  #ifndef MODULE
> @@ -5638,7 +5644,7 @@ int __init sbpcd_init(void)
>  #endif
>  {
>         int i=0, j=0;

Blank line between variable declarations and code please.

> -       int addr[2]={1, CDROM_PORT};
> +       addr[2]={1, CDROM_PORT};
>         int port_index;

Keep the variables together and seperate from the code. Like this :

{
       int i=0, j=0;
       int port_index;

       addr[2]={1, CDROM_PORT};
...


>
>         sti();

Just in case you are bored, at some point those cli()/sti() need to go
away as well and be replaced with proper locking. But that's a
different patch :-)

> @@ -5670,9 +5676,9 @@ int __init sbpcd_init(void)
>         {
>                 addr[1]=sbpcd[port_index];
>                 if (addr[1]==0) break;
> -               if (check_region(addr[1],4))
> +               if (!request_region(addr[1],4, "sbpcd driver"))
>                 {
> -                       msg(DBG_INF,"check_region: %03X is not free.\n",addr[1]);
> +                       msg(DBG_INF,"request_region: %03X is not free.\n",addr[1]);
>                         continue;
>                 }
>                 if (sbpcd[port_index+1]==2) type=str_sp;
> @@ -5699,6 +5705,7 @@ int __init sbpcd_init(void)
>         if (ndrives==0)
>         {
>                 msg(DBG_INF, "No drive found.\n");
> +               release_region(addr[1],4);

If we get here after actually having obtained a region an ndrives is
then 0, then we should ofcourse release the region before we bail out.
makes sense.

>  #ifdef MODULE
>                 return -EIO;
>  #else
> @@ -5775,6 +5782,7 @@ int __init sbpcd_init(void)
>         if (!request_region(CDo_command,4,major_name))
>         {
>                 printk(KERN_WARNING "sbpcd: Unable to request region 0x%x\n", CDo_command);
> +               release_region(addr[1],4);
>                 return -EIO;
>         }
>

This makes sense. If we bail out due to not being able to obtain the
CDo_command region, then we should release the other region.

> @@ -5788,6 +5796,8 @@ int __init sbpcd_init(void)
>  #endif /* SOUND_BASE */
>
>         if (register_blkdev(MAJOR_NR, major_name)) {
> +               release_region(CDo_command,4);
> +               release_region(addr[1],4);
>  #ifdef MODULE
>                 return -EIO;
>  #else
> @@ -5801,6 +5811,7 @@ int __init sbpcd_init(void)
>         sbpcd_queue = blk_init_queue(do_sbpcd_request, &sbpcd_lock);
>         if (!sbpcd_queue) {
>                 release_region(CDo_command,4);
> +               release_region(addr[1],4);
>                 unregister_blkdev(MAJOR_NR, major_name);
>                 return -ENOMEM;
>         }
> @@ -5834,6 +5845,7 @@ int __init sbpcd_init(void)
>                                 printk("Can't unregister %s\n", major_name);
>                         }
>                         release_region(CDo_command,4);
> +                       release_region(addr[1],4);
>                         blk_cleanup_queue(sbpcd_queue);
>                         return -EIO;
>                 }
> @@ -5850,6 +5862,7 @@ int __init sbpcd_init(void)
>                 if (sbpcd_infop == NULL)
>                 {
>                          release_region(CDo_command,4);
> +                       release_region(addr[1],4);
>                         blk_cleanup_queue(sbpcd_queue);
>                          return -ENOMEM;
>                 }
> @@ -5894,6 +5907,7 @@ static void sbpcd_exit(void)
>                 return;
>         }
>         release_region(CDo_command,4);
> +       release_region(addr[1],4);
>         blk_cleanup_queue(sbpcd_queue);
>         for (j=0;j<NR_SBPCD;j++)
>         {
>
> Kindly update if this is Ok. I will proceed with the original patch.
>

This looks a lot better to me. I have only given it a quick look, but
I don't see any major problems.

> -surya.
>
>  The information contained in this electronic message and any attachments to this message are intended for the exclusive use of the addressee(s) and may contain proprietary, confidential or privileged information. If you are not the intended recipient, you should not disseminate, distribute or copy this e-mail. Please notify the sender immediately and destroy all copies of this message and any attachments.   WARNING: Computer viruses can be transmitted via email. The recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.   www.wipro.com
>
Please tell your mail client not to include crap like that when
sending to public mailing lists.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
