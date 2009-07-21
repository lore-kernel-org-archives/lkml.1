Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZGUCtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZGUCtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZGUCtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:49:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZGUCtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:49:01 -0400
Date: Mon, 20 Jul 2009 19:45:57 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Greg KH <greg@kroah.com>, Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 27/54] Staging: hv: remove ULONG and LONG typedefs
Message-ID: <20090721024557.GA17242@suse.de>
References: <20090717180850.873962925@mini.kroah.org>
 <20090717180920.285605541@mini.kroah.org>
 <200907210200.16295.arnd@arndb.de>
 <20090721023823.GA12154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721023823.GA12154@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 07:38:23PM -0700, Greg KH wrote:
> On Tue, Jul 21, 2009 at 02:00:16AM +0200, Arnd Bergmann wrote:
> > On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> > > From: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > The ULONG and LONG typedefs are now removed from the Hyper-V driver
> > > code
> > > 
> > 
> > This conversion is not equivalent:
> > 
> > >  //
> > > -// unsigned types
> > > -//
> > > -typedef unsigned int		ULONG;
> > > -
> > > -//
> > > -// signed types
> > > -//
> > > -typedef int					LONG;
> > 
> > - // redefine the world, because we can
> > - extern char *i;
> > - void abs(unsigned u);
> > - #define FALSE (2)
> > 
> > ;-)
> > 
> > > --- a/drivers/staging/hv/include/StorVscApi.h
> > > +++ b/drivers/staging/hv/include/StorVscApi.h
> > > @@ -117,7 +117,7 @@ typedef struct _STORVSC_DRIVER_OBJECT {
> > >  } STORVSC_DRIVER_OBJECT;
> > >  
> > >  typedef struct _STORVSC_DEVICE_INFO {
> > > -	ULONG	PortNumber;
> > > +	unsigned long	PortNumber;
> > >      unsigned char	PathId;
> > >      unsigned char	TargetId;
> > >  } STORVSC_DEVICE_INFO;
> > 
> > If this is an API (as the header file name suggests), you just changed it.
> > Same for the other hunks in this patch.
> 
> Ah crap, you're right, that's all wrong, nice catch.
> 
> I'll go redo it to be "unsigned int", but for some reason, the code
> still seems to work properly :)

Ok, here's the updated version.  Thanks for the review.

Hank, a lot of these should probably be converted to "real" kernel
types, like u32, or u64 if it's really needed.  Especially if they are
crossing the kernel/hypervisor boundry.

thanks,

greg k-h

-------------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Staging: hv: remove ULONG and LONG typedefs

From: Greg Kroah-Hartman <gregkh@suse.de>

The ULONG and LONG typedefs are now removed from the Hyper-V driver
code.

Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/StorVsc.c            |    2 +-
 drivers/staging/hv/include/StorVscApi.h |    2 +-
 drivers/staging/hv/include/osd.h        |   10 ----------
 drivers/staging/hv/include/vstorage.h   |   12 ++++++------
 4 files changed, 8 insertions(+), 18 deletions(-)

--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -62,7 +62,7 @@ typedef struct _STORVSC_DEVICE{
 
 	//  Each unique Port/Path/Target represents 1 channel ie scsi controller. In reality, the pathid, targetid is always 0
 	// and the port is set by us
-	ULONG						PortNumber;
+	unsigned int						PortNumber;
     unsigned char						PathId;
     unsigned char						TargetId;
 
--- a/drivers/staging/hv/include/StorVscApi.h
+++ b/drivers/staging/hv/include/StorVscApi.h
@@ -117,7 +117,7 @@ typedef struct _STORVSC_DRIVER_OBJECT {
 } STORVSC_DRIVER_OBJECT;
 
 typedef struct _STORVSC_DEVICE_INFO {
-	ULONG	PortNumber;
+	unsigned int	PortNumber;
     unsigned char	PathId;
     unsigned char	TargetId;
 } STORVSC_DEVICE_INFO;
--- a/drivers/staging/hv/include/osd.h
+++ b/drivers/staging/hv/include/osd.h
@@ -95,16 +95,6 @@ typedef struct _DLIST_ENTRY {
 } DLIST_ENTRY;
 
 //
-// unsigned types
-//
-typedef unsigned int		ULONG;
-
-//
-// signed types
-//
-typedef int					LONG;
-
-//
 // Other types
 //
 typedef unsigned long		SIZE_T;
--- a/drivers/staging/hv/include/vstorage.h
+++ b/drivers/staging/hv/include/vstorage.h
@@ -155,7 +155,7 @@ typedef struct
     unsigned char DataIn;
     unsigned char Reserved;
 
-    ULONG DataTransferLength;
+    unsigned int DataTransferLength;
 
     union
     {
@@ -185,11 +185,11 @@ typedef struct
     //
     // Note: port number is only really known on the client side
     //
-    ULONG  PortNumber;
+    unsigned int  PortNumber;
 
-    ULONG  Flags;
+    unsigned int  Flags;
 
-    ULONG  MaxTransferBytes;
+    unsigned int  MaxTransferBytes;
 
     //
     //  This id is unique for each channel and will correspond with
@@ -249,13 +249,13 @@ typedef struct _VSTOR_PACKET
     //  Flags - see below for values
     //
 
-    ULONG     Flags;
+    unsigned int     Flags;
 
     //
     // Status of the request returned from the server side.
     //
 
-    ULONG     Status;
+    unsigned int     Status;
 
     //
     // Data payload area
