Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYBIW3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYBIW3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYBIW2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:28:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:9298 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbYBIW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:28:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YA7Iv2U5cO4+PaRfGD6OZNYNOohT+wj0tBU2Q9jq7a9oqUj6b7ss5uKXGtms5n2ZVUePfskcof3BYZ8c3sLym4yqrjaodgg0PqGdF8TJPyag7URfLFVGG+6qXMRU/vmWyxGrkENYJ3snDCYYc687L4ytXE1KFzJVf6AgLHILdpg=
Message-ID: <86802c440802091428v87a10f5h280ae1d82b1db6a@mail.gmail.com>
Date: Sat, 9 Feb 2008 14:28:46 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: ses fix for len and mem leaking when fail to add intf
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com
In-Reply-To: <1202569242.4254.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802090413.53275.yinghai.lu@sun.com>
	 <1202569242.4254.9.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 7:00 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Sat, 2008-02-09 at 04:13 -0800, Yinghai Lu wrote:
> > [PATCH] scsi: ses fix for len and mem leaking when fail to add intf
> >
> > change to u32 before left shifting char
>
> This one is a bit unnecessary; C promotion rules guarantee that
> everything is promoted to int (or above) before doing arithmetic.  Since
> it's only ever done on 16 bits, signed or unsigned int is adequate for
> the conversion.

thank. just learned that.

yhlu@yhlunb:~/xx/xx/notes> cat ctest.c
#include <stdio.h>
int main(int argc, char *argv[])
{
        unsigned char buf[20];
        int len;

        buf[2] = 0x02;
        buf[3] = 0x03;

        len = (buf[2] << 8) + buf[3];

        printf("len = %x\n", len);
        return 0;
}
yhlu@yhlunb:~/xx/xx/notes> gcc -o ctest ctest.c
yhlu@yhlunb:~/xx/xx/notes> ./ctest
len = 203
yhlu@yhlunb:~/xx/xx/notes>


>
> > also fix leaking with scomp leaking when failing.
>
> Yes, I see that, thanks!  There's also the kmalloc of scomp which should
> be kzalloc if you care to fix that up in the resend.
>
> > -             edev =  enclosure_find(&sdev->host->shost_gendev);
> > +             edev = enclosure_find(&sdev->host->shost_gendev);
>
> Space cleanups also need mention in the changelog.
>
> > -     ses_dev->page1 = buf;
> > -     ses_dev->page1_len = len;
> > -
> >       result = ses_recv_diag(sdev, 1, buf, len);
> >       if (result)
> >               goto recv_failed;
> >
> > +     ses_dev->page1 = buf;
> > +     ses_dev->page1_len = len;
> > +
>
> Neither of us gets this right.  By removing the kfree(buf) from the
> err_free path, you cause a leak here.  I cause a double free.  I think
> putting back the kfree(buf) and keeping this hunk is the fix.

the buf already become sdev->page1, sdev->pag10, sdev->page2.
so it will be freed via them

>
> >       types = buf[10];
> >       len = buf[11];
> >
> > @@ -474,11 +474,12 @@ static int ses_intf_add(struct class_dev
> >                       components += type_ptr[1];
> >       }
> >
> > +     buf = NULL;
>
> Yes, prevents double free (but only if buf is freed).

it became sdev->page1 already

>
> >       result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
> >       if (result)
> >               goto recv_failed;
> >
> > @@ -492,11 +493,12 @@ static int ses_intf_add(struct class_dev
> >
> >       /* The additional information page --- allows us
> >        * to match up the devices */
> > +     buf = NULL;
>
> It's probably better to move these closer to the statements that make
> them necessary (in this case above the comment).

OK

>
> >       if (IS_ERR(edev)) {
> >               err = PTR_ERR(edev);
> > +             kfree(scomp);
> >               goto err_free;
> >       }
>
> kfree(scomp) should be in the err_free path just in case someone else
> adds something to this.

ok.

>
> >       /* add 1 for trailing '\0' we'll use */
> >       buf = kzalloc(len + 1, GFP_KERNEL);
> > -     result = ses_recv_diag(sdev, 7, buf, len);
> > -     if (result) {
> > +     if (buf)
> > +             result = ses_recv_diag(sdev, 7, buf, len);
> > +     else
> > +             result = 7;
> > +
>
> What exactly is this supposed to be doing, and why 7?  If you're
> thinking of conditioning the page 7 receive on the success of the
> allocation, we really need the allocation failure report more than we
> need the driver to attach.

want to move out label out of if later.

>
> > -                                     addl_desc_ptr += addl_desc_ptr[1] + 2;
> > +                                     addl_desc_ptr += 2 + addl_desc_ptr[1];
>
> This is rather pointless, isn't it?
>
> >   err_free:
> > -     kfree(buf);
>
> You can't remove this.  Also add kfree(scomp) here.
