Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXHGMvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXHGMvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbXHGMvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:51:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54377 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759120AbXHGMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:51:08 -0400
X-Sasl-enc: nZSLT4M+tD82BI0vabLIYxitQxb2FZ6vsIfGpXH+EeZF 1186491067
Date: Tue, 7 Aug 2007 09:51:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070807125104.GC30661@khazad-dum.debian.net>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <1186411815.4355.7.camel@nx6310> <20070806150159.GC31615@khazad-dum.debian.net> <200708061732.03425.rjw@sisk.pl> <46B75459.9020204@gmail.com> <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com> <20070806234509.GC27640@khazad-dum.debian.net> <46B816FF.7060303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B816FF.7060303@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Tejun Heo wrote:
> Henrique de Moraes Holschuh wrote:
> > On Tue, 07 Aug 2007, Tejun Heo wrote:
> >> Michael Sedkowski wrote:
> >>>> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
> >>>> pulling unnecessary stunt.  Please apply the attached patch and report
> >>>> when the disk spins down and up.
> >>> Disk spins down on "Pre-shutdown prepare" and then goes up and down on
> >>> "Power down".
> >> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> >> it spins down the disk correctly.  Does emergency unload count increase
> >> after each power down?  Also, please post the result of 'dmidecode'.
> > 
> > You know, this actually make a lot of sense, and one can't even complain
> > about firmware that pulls that off.
> 
> Well, I'm complaining.  I think the problem here is that it isn't clear
> which one is who's responsibility.  There's a Korean saying which

The BIOS *has* to do it when in DOS mode, the HD manuals are very very clear
about it.  Doing it through ACPI ATA objects is at least non-broken as far
as these things go, as one knows when to do it directly ("non-ACPI mode"),
and one doesn't talk to the disk directly.

> approximately translates into "if you have too many boatmen on a ship,
> it goes to mountain".  We also have a bunch of Toshiba laptops which

Yeah, that's a problem.  But we can avoid it if we start snooping what ACPI
is asking us to deliver to the disks, which IMO is an extremely good idea
anyway.

> want the ATA controller to be in enabled state when ACPI suspend is
> invoked because the suspend method apparently wants to execute some
> commands before going to sleep.

That's just broken, since it is not even using a OS-backed SATA/ATA ACPI
method to do it.

> I wish ACPI spec carries a big fat sign saying "stay f*** away from
> anything which isn't essential to the requested operation".

Shutting down disks *is* essential to the power off operation.  ACPI would
have to mandate who is to do it, instead (ACPI table or OSI by itself).

> > Any chances of changing things
> > so that we inspect/snoop all tasks sent to the device, and filter them
> > out, or react to them accordingly?
> 
> No, we can't unless we snoop ACPI method execution and detect accesses
> to IO ports or iomem regions.  It's not going through any driver.  This
> is a gross mess.

I don't mean fixing the stuff clowns like Toshiba did.  The correct fix for
that is to blacklist the hell out of that crap and patch their DSDT into
something remotely sane.

I do mean snooping the ACPI methods that *return* a taskset to send to the
driver, and we send that taskset ourselves in libata and libpata(?).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
