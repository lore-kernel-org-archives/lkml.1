Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYEHTSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYEHTSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbYEHTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:18:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:57143 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150AbYEHTSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:18:31 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [patch 00/16] Linux 2.6.25 -stable review
Date: Thu, 8 May 2008 15:16:28 -0400
User-Agent: KMail/1.9.9
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>
References: <20080508174122.GA855@suse.de> <20080508182233.GB2115@suse.de> <20080508183324.GA1874@1wt.eu>
In-Reply-To: <20080508183324.GA1874@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081516.29907.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008, Willy Tarreau wrote:
> On Thu, May 08, 2008 at 11:22:33AM -0700, Greg KH wrote:
> > On Thu, May 08, 2008 at 08:13:42PM +0200, Willy Tarreau wrote:
> > > On Thu, May 08, 2008 at 10:41:22AM -0700, Greg KH wrote:
> > > > This is the start of the stable review cycle for the 2.6.25.2 release.
> > > > There are 16 patches in this series, all will be posted as a response to
> > > > this one.  If anyone has any issues with these being applied, please let
> > > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > > to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > > Greg, shouldn't we also queue this one (may be in a later version) ? It's
> > > in mainline.
> > 
> > What problem does it solve?
> 
> from what I see in the code, currently acpi_power_get_state() will return
> 0 when setting resource to NULL, and some callers (eg: acpi_power_on())
> will happily dereference resource if acpi_power_get_state() returns 0. So
> I guess there are circumstances where we can oops.
> 
> > Does Len want it in -stable?
> 
> I simply forgot to ask. I'm CCing him.

This patch is correct.

Go ahead and apply it -- it won't hurt anything.
I don't think it will help anything in real-life either, though.

While it is true if we had this failure, we'd oops in acpi_power_on() and acpi_power_off().
But I think this is effectively a check for a programming error that we
don't (currently) have.  ie. acpi_power_add() always does this:
acpi_driver_data(device) = resource; with a valid pointer.
So the fact that this error check was a errantly a NO-OP was hidden in practice.

-Len

> > 
> > > >From a815ab8b5891f3d2515316655729272f68269e3b Mon Sep 17 00:00:00 2001
> > > From: Li Zefan <lizf@cn.fujitsu.com>
> > > Date: Fri, 18 Apr 2008 13:27:29 -0700
> > > Subject: ACPI: check a return value correctly in acpi_power_get_context()
> > > 
> > > We should check *resource != NULL rather than resource != NULL, which will be
> > > always true.
> > > 
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > Acked-by: Zhao Yakui <yakui.zhao@intel.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Len Brown <len.brown@intel.com>
> > > ---
> > >  drivers/acpi/power.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > > index 76bf6d9..f2a76ac 100644
> > > --- a/drivers/acpi/power.c
> > > +++ b/drivers/acpi/power.c
> > > @@ -121,7 +121,7 @@ acpi_power_get_context(acpi_handle handle,
> > >  	}
> > >  
> > >  	*resource = acpi_driver_data(device);
> > > -	if (!resource)
> > > +	if (!*resource)
> > >  		return -ENODEV;
> > >  
> > >  	return 0;
> > > -- 
> > > 1.5.3.8
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


