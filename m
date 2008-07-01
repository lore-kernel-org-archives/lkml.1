Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYGAUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYGAUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYGAUgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:36:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbYGAUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:36:07 -0400
Date: Tue, 1 Jul 2008 13:35:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH -next] bug.h: add empty warn_on_slowpath() for
 CONFIG_BUG=n
Message-Id: <20080701133535.f92a673c.akpm@linux-foundation.org>
In-Reply-To: <23433248.1214943818230.JavaMail.oracle@acsmt302.oracle.com>
References: <20080701103339.b5acc1f3.randy.dunlap@oracle.com>
	<20080701131714.5093fa49.akpm@linux-foundation.org>
	<23433248.1214943818230.JavaMail.oracle@acsmt302.oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 15:23:38 -0500 (CDT)
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> --- Original Message ---
> > On Tue, 1 Jul 2008 10:33:39 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Add an empty function for warn_on_slowpath() when CONFIG_BUG=n so that
> > > this build error does not happen:
> > > 
> > > linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
> > > linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > ---
> > >  include/asm-generic/bug.h |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > --- linux-next-20080701.orig/include/asm-generic/bug.h
> > > +++ linux-next-20080701/include/asm-generic/bug.h
> > > @@ -81,4 +81,9 @@ extern void warn_on_slowpath(const char 
> > >  # define WARN_ON_SMP(x)			do { } while (0)
> > >  #endif
> > >  
> > > +#ifndef __ASSEMBLY__
> > > +static inline void warn_on_slowpath(const char *file, const int line)
> > > +{ }
> > > +#endif
> > > +
> > >  #endif
> > > 
> > 
> > This looks like a needed-in-mainline fix?  or is there something
> > in linux-next which causes the bug?
> 
> Looks like only linux-next has this code:
> 
> > > linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
> > > linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'
> 

err...


commit 9e030ab0bffdc8b6d8be663b639bd5e2374537f0
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jun 24 22:47:09 2008 -0400

    ACPI: add standard linux WARN_ON() output to ACPI errors and exceptions
    
    In linux-2.6.27, we expect WARN() with printk semantics
    to become available, and we'll be able to simplify
    this code.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/utilities/utmisc.c b/drivers/acpi/utilities/utmisc.c
index 1f057b7..0a340b0 100644
--- a/drivers/acpi/utilities/utmisc.c
+++ b/drivers/acpi/utilities/utmisc.c
@@ -1028,6 +1028,7 @@ acpi_ut_error(char *module_name, u32 line_number, char *format, ...)
 {
 	va_list args;
 
+	warn_on_slowpath(module_name, line_number);
 	acpi_os_printf("ACPI Error (%s-%04d): ", module_name, line_number);
 
 	va_start(args, format);
@@ -1042,6 +1043,7 @@ acpi_ut_exception(char *module_name,
 {
 	va_list args;
 
+	warn_on_slowpath(module_name, line_number);
 	acpi_os_printf("ACPI Exception (%s-%04d): %s, ", module_name,
 		       line_number, acpi_format_exception(status));
 


Was there any particular reason for doing it this way?  It's really
quite wrong, given that an architecture can provide its own definition
of WARN_ON() and __WARN() and might not even implement
warn_on_slowpath() at all.

The usual way of doing this is to go in via the front door: WARN_ON(1).
