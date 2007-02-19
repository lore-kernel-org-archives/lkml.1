Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXBSKkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXBSKkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXBSKkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:40:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:37165 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXBSKka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:40:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UWg9r+5GFYFWvXCWZglTZ71ZIpZWLveSs1bD1xM28sH6+HNUuKBWd5nJfEvwkeikhXDhRSIYQdsIZW10ysKYgWZ19n920V1NdEjARUx0bTsi7rCioSMbsugqNjN4htUO75ze37wFnUY2F9LSlYVUIf7f5bveNcEYww5CGzTjtmc=
Message-ID: <d9def9db0702190240l33f0b1e3p508d1e7b65e5e48c@mail.gmail.com>
Date: Mon, 19 Feb 2007 11:40:27 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Eric Piel" <Eric.Piel@tremplin-utc.net>
Subject: Re: smartcard reader + pcmcia/pccard subsystem problems
Cc: "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after doing some code review it seems like I found 2 bugs.
a.) deadlock within the pccard/pcmcia framework
b.) slab corruption when unloading the driver

a.) it's easy to reproduce a, just run

$ while :; do pccardctl eject; pccardctl insert; done

concurrently on 2 shells.

another way to reproduce it is:

$ while :; do insmod oz...ko; pccardctl insert; pccardctl eject; rmmod
oz...ko; done

(it's sufficient to run that on one shell)

The bug is sysfs related, there are 2 locks one to protect critical
parts of the pccard/pcmcia framework, the other one to lock the sysfs
inode. I'll try to commit a patch for this during the next few days I
was able to solve one problem there already.

b.) slab corruption; it's a bit difficult to reproduce since a. might
lock up the device before anything shows up. So I haven't done much
here yet.

Markus


On 2/17/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> Hi Eric,
>
> I committed your code to linuxtv.org to review and modify it there.
> http://linuxtv.org/hg/~mrechberger/chipcardreader
>
> one thing I noticed is the error handling in ozscr_probe.
>
> I'll continue the rest during the next few days, I'd like to see it as
> soon as possible in the upstream kernel before some kernel api changes
> again which affects your current driver.
>
> Markus
>
> On 2/17/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > Hi,
> >
> > so finally I'm also looking at that driver,
> > http://pieleric.free.fr/o2scr/
> > the driver compiles fine, though it doesn't seem to work (unless I'm
> > doing something wrong here)
> >
> > dmesg shows up following entries:
> >
> > pccard: card ejected from slot 1
> > PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
> > pccard: PCMCIA card inserted into slot 1
> > pcmcia: registering new device pcmcia1.0
> > pccard: card ejected from slot 1
> > PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
> > pccard: PCMCIA card inserted into slot 1
> > pcmcia: registering new device pcmcia1.0
> > pccard: card ejected from slot 1
> > PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
> > pccard: PCMCIA card inserted into slot 1
> > pcmcia: registering new device pcmcia1.0
> > OZSCRLX O2Micro SmartCardBus Reader (for kernel >= 2.6.17)
> >
> > The module for any reason has a usecount value of 1
> > ozscrlx                21548  1
> >
> > devicenode /dev/ozscrlx isn't opened anywhere either.
> >
> > I'll do some further investigations uppon it, I'd also like to see it
> > directly in the kernel. It would be handy to use for encrypted
> > filesystems.
> >
> > Markus
> >
> >
> > On 12/12/06, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> > > 28.11.2006 12:49, Oliver Neukum wrote/a écrit:
> > > >> Latest version I've published is there:
> > > >> http://pieleric.free.fr/o2scr/
> > > >
> > > >         case OZSCR_OPEN: /* Request ICC */
> > > >             dprintk("OZSCR_OPEN\n");
> > > >             ATRLength = ATR_SIZE;
> > > >             pRdrExt->IOBase = (PSCR_REGISTERS *) dev->io_base; //XXX
> > > necessary?
> > > >             pRdrExt->membase = dev->am_base; //XXX necessary?
> > > >
> > > >             pRdrExt->m_SCard.AvailableProtocol = 0;
> > > >             pRdrExt->m_SCard.RqstProtocol = 0;
> > > >             dprintk("membase:%p\n", pRdrExt->membase);
> > > >             dprintk("ioport:0x%03x\n", (unsigned)pRdrExt->IOBase);
> > > >
> > > >             ret = CmdResetReader( pRdrExt, FALSE, ATRBuffer,
> &ATRLength
> > );
> > > >             apdu.LengthOut = ATRLength;
> > > >
> > > > #ifdef PCMCIA_DEBUG
> > > >             printk(KERN_DEBUG "Open finished, ATR buffer = ");
> > > >             for( ATRLength = 0; ATRLength < apdu.LengthOut;
> ATRLength++
> > )
> > > >                 printk(" [%02X] ", ATRBuffer[ATRLength] );
> > > >             printk("\n");
> > > > #endif
> > > >
> > > >             memcpy( apdu.DataOut, ATRBuffer, ATRLength );
> > > >             ret = copy_to_user((struct ozscr_apdu *)arg, &apdu,
> > > sizeof(struct ozscr_apdu));
> > > >             break;
> > > >
> > > > 1. This needs locking against concurrent ioctls
> > > > 2. The interpretation of copy_to_user()'s return code is incorrect
> > > >
> > >
> > > Hi Oliver,
> > >
> > > Thanks a lot for reading my code, I didn't even hope that someone
> would!
> > > I've corrected the copy_to_user (and copy_from_user) code. However I
> > > don't know how to do locking for the concurrent ioctls. Indeed, I don't
> > > think there is anything preventing two programs to call the driver at
> > > the same time. Unfortunately, I've got no idea how to do the locking
> and
> > > surprisingly couldn't find any ioctl code in the kernel doing locking.
> > > Maybe I've just not looked at the right place, could you give a me some
> > > hint how to do locking for ioctl's ?
> > >
> > > See you,
> > > Eric
> > >
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> >
> >
> > --
> > Markus Rechberger
> >
>
>
> --
> Markus Rechberger
>


-- 
Markus Rechberger
