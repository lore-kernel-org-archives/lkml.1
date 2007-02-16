Return-Path: <linux-kernel-owner+w=401wt.eu-S1946293AbXBPXgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946293AbXBPXgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946294AbXBPXgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:36:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:19449 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946293AbXBPXgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eAZ3L/fyFCAHS4k4Adq5gettrCPiLBC5I8LBJpE4OiXgxso3aEecntRXXZo8hB/50hGNLjMGOjk7IyL/7rkF9lDpj8e6hqoXb6mAmEL1ofPKZ+eQLm7+AkokI6CAwXChx00eZqXXs19664nW5CVj07ZpeFCJMgVvSODSNs+qFXs=
Message-ID: <d9def9db0702161536i64cf6fb3o1c3c8ff850c38994@mail.gmail.com>
Date: Sat, 17 Feb 2007 00:36:10 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Eric Piel" <Eric.Piel@tremplin-utc.net>
Subject: Re: O2micro smartcard reader driver.
Cc: "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org
In-Reply-To: <457F1F0F.20109@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20061127182817.d52dfdf1.l.bigonville@edpnet.be>
	 <456C0BD0.7080606@tremplin-utc.net>
	 <200611281249.45243.oliver@neukum.org>
	 <457F1F0F.20109@tremplin-utc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so finally I'm also looking at that driver,
http://pieleric.free.fr/o2scr/
the driver compiles fine, though it doesn't seem to work (unless I'm
doing something wrong here)

dmesg shows up following entries:

pccard: card ejected from slot 1
PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
pccard: PCMCIA card inserted into slot 1
pcmcia: registering new device pcmcia1.0
pccard: card ejected from slot 1
PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
pccard: PCMCIA card inserted into slot 1
pcmcia: registering new device pcmcia1.0
pccard: card ejected from slot 1
PCMCIA: socket c160c364: *** DANGER *** unable to remove socket power
pccard: PCMCIA card inserted into slot 1
pcmcia: registering new device pcmcia1.0
OZSCRLX O2Micro SmartCardBus Reader (for kernel >= 2.6.17)

The module for any reason has a usecount value of 1
ozscrlx                21548  1

devicenode /dev/ozscrlx isn't opened anywhere either.

I'll do some further investigations uppon it, I'd also like to see it
directly in the kernel. It would be handy to use for encrypted
filesystems.

Markus


On 12/12/06, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> 28.11.2006 12:49, Oliver Neukum wrote/a écrit:
> >> Latest version I've published is there:
> >> http://pieleric.free.fr/o2scr/
> >
> >         case OZSCR_OPEN: /* Request ICC */
> >             dprintk("OZSCR_OPEN\n");
> >             ATRLength = ATR_SIZE;
> >             pRdrExt->IOBase = (PSCR_REGISTERS *) dev->io_base; //XXX
> necessary?
> >             pRdrExt->membase = dev->am_base; //XXX necessary?
> >
> >             pRdrExt->m_SCard.AvailableProtocol = 0;
> >             pRdrExt->m_SCard.RqstProtocol = 0;
> >             dprintk("membase:%p\n", pRdrExt->membase);
> >             dprintk("ioport:0x%03x\n", (unsigned)pRdrExt->IOBase);
> >
> >             ret = CmdResetReader( pRdrExt, FALSE, ATRBuffer, &ATRLength );
> >             apdu.LengthOut = ATRLength;
> >
> > #ifdef PCMCIA_DEBUG
> >             printk(KERN_DEBUG "Open finished, ATR buffer = ");
> >             for( ATRLength = 0; ATRLength < apdu.LengthOut; ATRLength++ )
> >                 printk(" [%02X] ", ATRBuffer[ATRLength] );
> >             printk("\n");
> > #endif
> >
> >             memcpy( apdu.DataOut, ATRBuffer, ATRLength );
> >             ret = copy_to_user((struct ozscr_apdu *)arg, &apdu,
> sizeof(struct ozscr_apdu));
> >             break;
> >
> > 1. This needs locking against concurrent ioctls
> > 2. The interpretation of copy_to_user()'s return code is incorrect
> >
>
> Hi Oliver,
>
> Thanks a lot for reading my code, I didn't even hope that someone would!
> I've corrected the copy_to_user (and copy_from_user) code. However I
> don't know how to do locking for the concurrent ioctls. Indeed, I don't
> think there is anything preventing two programs to call the driver at
> the same time. Unfortunately, I've got no idea how to do the locking and
> surprisingly couldn't find any ioctl code in the kernel doing locking.
> Maybe I've just not looked at the right place, could you give a me some
> hint how to do locking for ioctl's ?
>
> See you,
> Eric
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
