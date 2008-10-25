Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJYLTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJYLTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYJYLS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:18:59 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:60780 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJYLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:18:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMBAJOcAklR9VdV/2dsb2JhbAAIwFaDTw
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-uvc-devel@lists.berlios.de
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo stress test
Date: Sat, 25 Oct 2008 13:19:07 +0200
User-Agent: KMail/1.9.9
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <gbiduj$9p3$1@ger.gmane.org> <48F710F7.9030608@tuffmail.co.uk> <20081024123129.3c373b90@pedra.chehab.org>
In-Reply-To: <20081024123129.3c373b90@pedra.chehab.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810251319.07232.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Friday 24 October 2008, Mauro Carvalho Chehab wrote:
> On Thu, 16 Oct 2008 11:01:27 +0100
>
> Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> > Laurent Pinchart wrote:
> > > Hi Alan,
> > >
> > > On Wednesday 15 October 2008, Alan Jenkins wrote:
> > >> Laurent Pinchart wrote:
> > >>> On Wednesday 15 October 2008, Alan Jenkins wrote:
> > >>>> If you look at the trace, it happens as "hald-probe-video" opens the
> > >>>> video device.  This is from Ubuntu 8.04.  Possibly it's significant
> > >>>> that I use the camera first, to make sure it works (I use Kopete,
> > >>>> the settings dialogue includes a video test).
> > >>>
> > >>> The NULL pointer (or rather 0x00000030 pointer) dereference happens
> > >>> in video_open:
> > >>>
> > >>>         file->f_op = fops_get(vfl->fops);
> > >>>         if (file->f_op->open)
> > >>>                 err = file->f_op->open(inode, file);
> > >>>
> > >>> file->f_op ends up being NULL. Either vfl->fops is NULL to begin
> > >>> with, or fops_get failed to get a reference to the file_operations
> > >>> structure.
> > >>>
> > >>> I'd be surprised if vfl->fops was NULL. To rule out that case, can
> > >>> you add a BUG_ON(vfl->fops == NULL) before the call to fops_get ?
> > >>>
> > >>> I'm not too familiar with the module loader, but a quick look at the
> > >>> code shows that the module could be marked as being unloaded
> > >>> (MODULE_STATE_GOING) before its exit function is called. If this is
> > >>> the case video_open would still be called, as the video device would
> > >>> still be registered, but fops_get would fail in try_module_get and
> > >>> return a NULL pointer. It seems the pointer returned by fops_get
> > >>> should be tested in video_open.
> > >>>
> > >>> I've CC'ed the v4l maintainer to get his opinion on this.
>
> Sorry for being late with this. Too much work here...
>
> I suspect that you only hit this bug due to BKL removal from open/close
> fops. maybe you're calling open() before having the device fully
> initialized?

It's actually the other way around. open() is closed while unloading the 
module. As v4l is being moved to cdev the bug will go away.

> Anyway, I think that the proposed check is interesting on other places
> where there are similar code.

Best regards,

Laurent Pinchart
