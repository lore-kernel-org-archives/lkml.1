Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXCNPhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXCNPhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXCNPhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:37:08 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:35842 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbXCNPhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:37:06 -0400
Date: Wed, 14 Mar 2007 11:37:05 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070314153705.GP22464@csclub.uwaterloo.ca>
References: <20070216185230.GO8882@enneenne.com> <20070313213842.GA23178@enneenne.com> <20070313224817.GF22466@csclub.uwaterloo.ca> <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com> <20070314141253.GM22464@csclub.uwaterloo.ca> <20070314142710.GJ3802@enneenne.com> <20070314144251.GN22464@csclub.uwaterloo.ca> <20070314145239.GK3802@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314145239.GK3802@enneenne.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well here is my current version of the refclock_nmea.c.patch for
LinuxPPS.  It now uses /dev/gps# for the nmea messages and /dev/pps# for
the PPS device (which in my case is of course the same device).  I am
running some more tests on it, but I think it is OK.

--- refclock_nmea.c.ori	2007-03-14 11:24:14.000000000 -0400
+++ refclock_nmea.c	2007-03-14 11:31:04.000000000 -0400
@@ -69,6 +69,7 @@
 # define DEVICE "COM%d:" 	/* COM 1 - 3 supported */
 #else
 # define DEVICE	"/dev/gps%d"	/* name of radio device */
+# define PPSDEVICE	"/dev/pps%d"	/* name of pps device */
 #endif
 #define	SPEED232	B4800	/* uart speed (4800 bps) */
 #define	PRECISION	(-9)	/* precision assumed (about 2 ms) */
@@ -79,6 +80,7 @@
 #define RANGEGATE	500000	/* range gate (ns) */
 
 #define LENNMEA		75	/* min timecode length */
+#define LENPPS		PPS_MAX_NAME_LEN
 
 /*
  * Tables to compute the ddd of year form icky dd/mm timecode. Viva la
@@ -99,6 +101,7 @@
 	pps_params_t pps_params; /* pps parameters */
 	pps_info_t pps_info;	/* last pps data */
 	pps_handle_t handle;	/* pps handlebars */
+	int handle_created;	/* pps handle created flag */
 #endif /* HAVE_PPSAPI */
 };
 
@@ -147,6 +150,11 @@
 	register struct nmeaunit *up;
 	struct refclockproc *pp;
 	int fd;
+#ifdef PPS_HAVE_FINDPATH
+	char id[LENPPS] = "",
+	     path[LENPPS],
+	     ppsdevice[LENPPS] = "";    /* just a default device */
+#endif	/* PPS_HAVE_FINDPATH */
 	char device[20];
 
 	/*
@@ -238,12 +246,26 @@
 	 * Start the PPSAPI interface if it is there. Default to use
 	 * the assert edge and do not enable the kernel hardpps.
 	 */
+#ifdef PPS_HAVE_FINDPATH
+	/* Get the PPS source's real name */
+	(void)sprintf(ppsdevice, PPSDEVICE, unit);
+	time_pps_readlink(ppsdevice, LENPPS, path, LENPPS);
+
+	/* Try to find the source */
+	fd = time_pps_findpath(path, LENPPS, id, LENPPS);
+	if (fd < 0) {
+		msyslog(LOG_ERR, "refclock_nmea: cannot find PPS path \"%s\" in the system", path);
+		return (0);
+	}
+	msyslog(LOG_INFO, "refclock_nmea: found PPS source \"%s\" at id #%d on \"%s\"", path, fd, id);
+#endif	/* PPS_HAVE_FINDPATH */
 	if (time_pps_create(fd, &up->handle) < 0) {
-		up->handle = 0;
+		up->handle_created = 0;
 		msyslog(LOG_ERR,
 		    "refclock_nmea: time_pps_create failed: %m");
 		return (1);
 	}
+	up->handle_created = ~0;
 	return(nmea_ppsapi(peer, 0, 0));
 #else
 	return (1);
@@ -265,8 +287,10 @@
 	pp = peer->procptr;
 	up = (struct nmeaunit *)pp->unitptr;
 #ifdef HAVE_PPSAPI
-	if (up->handle != 0)
+	if (up->handle_created) {
 		time_pps_destroy(up->handle);
+		up->handle_created = 0;
+	}
 #endif /* HAVE_PPSAPI */
 	io_closeclock(&pp->io);
 	free(up);
@@ -374,7 +398,7 @@
 	/*
 	 * Convert the timespec nanoseconds field to ntp l_fp units.
 	 */ 
-	if (up->handle == 0)
+	if (!up->handle_created)
 		return (0);
 	timeout.tv_sec = 0;
 	timeout.tv_nsec = 0;

--
Len Sorensen
