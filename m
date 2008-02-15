Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbYBOKu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbYBOKu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbYBOKuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:50:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:60615 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899AbYBOKuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:50:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=ZDMIzLNVu3TUHa+uHjPgkqn3VV3vEb4vFHdKcbvOnXjdvmlmHYhY0wC7nejB4GNT24zgnQIVI/BSdUlqauCAANbAkkS22eq3Og62u0cIrnjYjuXNTL/DROYzDopotgOjiFkWu31cs23D5gen5CiOksG+1bom183FsMD7Gn9fxew=
Date: Fri, 15 Feb 2008 11:50:31 +0100
To: Boris Petkov <petkovbb@googlemail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Message-ID: <20080215105031.GG13446@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Boris Petkov <petkovbb@googlemail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <200802121026.17420.hpj@urpla.net> <200802140037.51450.hpj@urpla.net> <20080214062652.GE13446@gollum.tnic> <200802141324.06731.bzolnier@gmail.com> <9ea470500802140542m325f05bdq256d3578950e4240@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ea470500802140542m325f05bdq256d3578950e4240@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 02:42:58PM +0100, Boris Petkov wrote:
> On 2/14/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Thursday 14 February 2008, Borislav Petkov wrote:
> > > On Thu, Feb 14, 2008 at 12:37:50AM +0100, Hans-Peter Jansen wrote:
> > >
> > > [Added Bart to CC]
> > >
> > > > Am Dienstag, 12. Februar 2008 schrieb Borislav Petkov:
> > > > > On Tue, Feb 12, 2008 at 10:26:17AM +0100, Hans-Peter Jansen wrote:
> > > > > > Hi,
> > > > > >
> > > > > > I suffer from unreliable cdrom operations (failing DAE and burn
> > > > > > sessions) with the openSUSE 2.6.18.8-0.7-bigsmp kernel.
> > > > >
> > > > >                   ^^^^
> > > > > Hi,
> > > > >
> > > > > can please you test this with a more recent kernel. Yours is almost
> > > > > ancient - from Sep. 2006.
> > > >
> > > > Sure, sorry. Here we go:
> > > >
> > > > Feb 14 00:18:18 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
> > > >  Trying to recover by ending request.
> > > > Feb 14 00:27:27 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
> > > >  Trying to recover by ending request.
> > > >
> > > > ~> uname -a
> > > > Linux xrated 2.6.24.1-35-pae #1 SMP 2008/02/12 01:00:18 UTC i686 athlon i386 GNU/Linux
> > >
> > > Actually the interrupt handler in ide-cd got rewritten and you're still using the
> > > old one (cdrom_pc_intr vs cdrom_newpc_intr). Those changes went into mainline before
> > > the 2.6.25-rc1 so we'll be able to test the new one only when you try out 2.6.25-rc1
> > > or wait until 2.6.25 is released in case you don't want to try hazardous materials
> > > such as an -rc kernel[*] :).
> > >
> > > Bart?
> > >
> > > *. As a matter of fact it runs quite smoothly on my machines.
> >
> > 2.6.25-rc1-git1 if you are using IDE.
> >
> > however it may still have this problem
> >
> >        if (ireason == 0) {
> >                write = 1;
> >                xferfunc = HWIF(drive)->atapi_output_bytes;
> >        } else if (ireason == 2 || (ireason == 1 &&
> >                   (blk_fs_request(rq) || blk_pc_request(rq)))) {
> >
> > we problably need to call ide_cd_check_ireason() also for REQ_TYPE_ATA_PC
> > requests and remove (blk_fs_request(rq) || blk_pc_request(rq) here
> >
> >                write = 0;
> >                xferfunc = HWIF(drive)->atapi_input_bytes;
> >        } else {
> >                printk(KERN_ERR "%s: %s: The drive "
> >                                "appears confused (ireason = 0x%02x). "
> >                                "Trying to recover by ending request.\n",
> >                                drive->name, __FUNCTION__, ireason);
> >                goto end_request;
> >        }
> >
> > Bart
> >
> Hans-Peter,
> 
> i will prepare a patch against 2.6.24 for you to try later.
Hi,

i thought that backporting ide-cd to 2.6.24 would be self-contained but the
problem is that it pulls in changes made in the block layer (ll_rw_blk.c splitup)
and if i pull those also in the patch, i can't guarantee the stability of your
system. Besides, this turns pretty fast into a chained pulling which will result
into a subset of 2.6.25-rc1 applied ontop of your 2.6.24.1 kernel so the only
alternative is to wait after 2.6.25 has been released and tackle the problem then.

-- 
Regards/Gruﬂ,
    Boris.
