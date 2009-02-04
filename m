Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbZBDNGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbZBDNGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbZBDMv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:51:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:64660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbZBDMv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:51:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
Date: Wed, 4 Feb 2009 13:51:17 +0100
User-Agent: KMail/1.9.9
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, alsa-devel@alsa-project.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <1232465902.3088.31.camel@localhost.localdomain> <1233747097.5563.29.camel@localhost.localdomain> <s5hk586a0mw.wl%tiwai@suse.de>
In-Reply-To: <s5hk586a0mw.wl%tiwai@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041351.18596.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19IBVIntMvtnm5crQeSZ/tQE8ruOuo6b0xYC0j
 OLDnX7I2/FH4upVr0xCpAO85lrINyymK9fnxkgjIQCBqlQ37RX
 2RJrxm7C434HKByccpgVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Takashi Iwai wrote:

> It's not always true -- that's the whole problem I'm concerned.
> Apparently old apps do include linux/soundcard.h.
> 
> I agree to remove the stuff causing warnings, i.e. moving oss-lib part
> to sys/soundcard.h.  In this case, the only possible regression is the
> case where apps use OSS-lib and include linux/soundcard.h.  For other
> cases (use sequencer stuff with linux/soundcard.h but without
> oss-lib), it will still work.

You cannot "move" things to <sys/soundcard.h>, because that file
is provided by glibc as a simple redirect to <linux/soundcard.h>.
The problem there is obviously the compatibility of combinations
of kernel and glibc before and after the change.

The use cases I can see include:

1. A simple app that only needs the ioctl definitions in
   linux/soundcard.h and does not care about all this.

2. A slightly more sophisticated app that uses the !OSSLIB part of
   <sys/soundcard.h> or <linux/soundcard.h>.

3. A new OSSlib application for OSS-3.9 or OSS-4.x that uses the
   <sys/soundcard.h> file provided by OSSlib, instead of the
   one from glibc.

4. A legacy OSSlib application from the last century using either
   linux/soundcard.h or sys/soundcard.h to get at the macros.

5. An application that gets compiled against <linux/soundcard.h>
   but linked against OSSlib 3.9 or 4.x.

Removing the macros and extern declarations from linux/soundcard.h
will break the final two cases. The only options I can see here
are "do nothing" and "screw them". 
Both should be fine, because the warning is easy to shut up
with a small preprocessor macro #define _SEQ_EXTERN extern,
and it's rather unlikely that anyone runs into this problem
on a 2.6 kernel in the first place.

	Arnd <><

---
This patch breaks building against OSSlib with the kernel headers
instead of its own headers. It should still work with any
version of the library from the 2003 onwards which provide
their own headers for the latest interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/include/linux/soundcard.h
+++ b/include/linux/soundcard.h
@@ -1045,7 +1045,7 @@ typedef struct mixer_vol_table {
  */
 #define LOCL_STARTAUDIO		1
 
-#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS) 
+#if !defined(__KERNEL__) || defined(USE_SEQ_MACROS)
 /*
  *	Some convenience macros to simplify programming of the
  *	/dev/sequencer interface
@@ -1056,39 +1056,15 @@ typedef struct mixer_vol_table {
 
 void seqbuf_dump(void);	/* This function must be provided by programs */
 
-extern int OSS_init(int seqfd, int buflen);
-extern void OSS_seqbuf_dump(int fd, unsigned char *buf, int buflen);
-extern void OSS_seq_advbuf(int len, int fd, unsigned char *buf, int buflen);
-extern void OSS_seq_needbuf(int len, int fd, unsigned char *buf, int buflen);
-extern void OSS_patch_caching(int dev, int chn, int patch,
-			      int fd, unsigned char *buf, int buflen);
-extern void OSS_drum_caching(int dev, int chn, int patch,
-			      int fd, unsigned char *buf, int buflen);
-extern void OSS_write_patch(int fd, unsigned char *buf, int len);
-extern int OSS_write_patch2(int fd, unsigned char *buf, int len);
-
 #define SEQ_PM_DEFINES int __foo_bar___
-#ifdef OSSLIB
-#  define SEQ_USE_EXTBUF() \
-		extern unsigned char *_seqbuf; \
-		extern int _seqbuflen;extern int _seqbufptr
-#  define SEQ_DEFINEBUF(len) SEQ_USE_EXTBUF();static int _requested_seqbuflen=len
-#  define _SEQ_ADVBUF(len) OSS_seq_advbuf(len, seqfd, _seqbuf, _seqbuflen)
-#  define _SEQ_NEEDBUF(len) OSS_seq_needbuf(len, seqfd, _seqbuf, _seqbuflen)
-#  define SEQ_DUMPBUF() OSS_seqbuf_dump(seqfd, _seqbuf, _seqbuflen)
-
-#  define SEQ_LOAD_GMINSTR(dev, instr) \
-		OSS_patch_caching(dev, -1, instr, seqfd, _seqbuf, _seqbuflen)
-#  define SEQ_LOAD_GMDRUM(dev, drum) \
-		OSS_drum_caching(dev, -1, drum, seqfd, _seqbuf, _seqbuflen)
-#else /* !OSSLIB */
-
-#  define SEQ_LOAD_GMINSTR(dev, instr)
-#  define SEQ_LOAD_GMDRUM(dev, drum)
-
-#  define SEQ_USE_EXTBUF() \
-		extern unsigned char _seqbuf[]; \
-		extern int _seqbuflen;extern int _seqbufptr
+
+#define SEQ_LOAD_GMINSTR(dev, instr)
+#define SEQ_LOAD_GMDRUM(dev, drum)
+
+#define _SEQ_EXTERN extern
+#define SEQ_USE_EXTBUF() \
+		_SEQ_EXTERN unsigned char _seqbuf[]; \
+		_SEQ_EXTERN int _seqbuflen;_SEQ_EXTERN int _seqbufptr
 
 #ifndef USE_SIMPLE_MACROS
 /* Sample seqbuf_dump() implementation:
@@ -1131,7 +1107,6 @@ extern int OSS_write_patch2(int fd, unsigned char *buf, int len);
  */
 #define _SEQ_NEEDBUF(len)	/* empty */
 #endif
-#endif /* !OSSLIB */
 
 #define SEQ_VOLUME_MODE(dev, mode)	{_SEQ_NEEDBUF(8);\
 					_seqbuf[_seqbufptr] = SEQ_EXTENDED;\
@@ -1215,14 +1190,8 @@ extern int OSS_write_patch2(int fd, unsigned char *buf, int len);
 		_CHN_COMMON(dev, MIDI_CHN_PRESSURE, chn, pressure, 0, 0)
 
 #define SEQ_SET_PATCH SEQ_PGM_CHANGE
-#ifdef OSSLIB
-#   define SEQ_PGM_CHANGE(dev, chn, patch) \
-		{OSS_patch_caching(dev, chn, patch, seqfd, _seqbuf, _seqbuflen); \
-		 _CHN_COMMON(dev, MIDI_PGM_CHANGE, chn, patch, 0, 0);}
-#else
-#   define SEQ_PGM_CHANGE(dev, chn, patch) \
+#define SEQ_PGM_CHANGE(dev, chn, patch) \
 		_CHN_COMMON(dev, MIDI_PGM_CHANGE, chn, patch, 0, 0)
-#endif
 
 #define SEQ_CONTROL(dev, chn, controller, value) \
 		_CHN_COMMON(dev, MIDI_CTL_CHANGE, chn, controller, 0, value)
@@ -1300,19 +1269,12 @@ extern int OSS_write_patch2(int fd, unsigned char *buf, int len);
 /*
  * Patch loading.
  */
-#ifdef OSSLIB
-#   define SEQ_WRPATCH(patchx, len) \
-		OSS_write_patch(seqfd, (char*)(patchx), len)
-#   define SEQ_WRPATCH2(patchx, len) \
-		OSS_write_patch2(seqfd, (char*)(patchx), len)
-#else
-#   define SEQ_WRPATCH(patchx, len) \
+#define SEQ_WRPATCH(patchx, len) \
 		{if (_seqbufptr) SEQ_DUMPBUF();\
 		 if (write(seqfd, (char*)(patchx), len)==-1) \
 		    perror("Write patch: /dev/sequencer");}
-#   define SEQ_WRPATCH2(patchx, len) \
+#define SEQ_WRPATCH2(patchx, len) \
 		(SEQ_DUMPBUF(), write(seqfd, (char*)(patchx), len))
-#endif
 
 #endif
 #endif
