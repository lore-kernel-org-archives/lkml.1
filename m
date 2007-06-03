Return-Path: <linux-kernel-owner+w=401wt.eu-S1764151AbXFCBq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764151AbXFCBq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 21:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763217AbXFCBqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 21:46:19 -0400
Received: from keil-draco.com ([216.193.185.50]:50937 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763143AbXFCBqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 21:46:18 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Prakash Punnoor <prakash@punnoor.de>
Subject: Re: [Trivial Patch] Remove JFFS2 dependency on internal Zlib header
Date: Sat, 2 Jun 2007 21:46:12 -0400
User-Agent: KMail/1.9.6
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706021520.36478.dhazelton@enter.net> <46620979.9020901@punnoor.de>
In-Reply-To: <46620979.9020901@punnoor.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_l1hYGwKcrszRlyw"
Message-Id: <200706022146.13083.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_l1hYGwKcrszRlyw
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 02 June 2007 20:21:13 Prakash Punnoor wrote:
> Daniel Hazelton wrote:
> > Signed-off-by: Daniel Hazelton <dhazelton@enter.net>
> >
> > DRH
> >
> > diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
> > index 2b87fcc..9f1b935 100644
> > --- a/fs/jffs2/compr_zlib.c
> > +++ b/fs/jffs2/compr_zlib.c
> > @@ -16,7 +16,6 @@
> >  #include <linux/kernel.h>
> >  #include <linux/slab.h>
> >  #include <linux/zlib.h>
> > -#include <linux/zutil.h>
> >  #include "nodelist.h"
> >  #include "compr.h"
> >
> > @@ -154,7 +153,7 @@ static int jffs2_zlib_decompress(unsigned char
> > *data_in,
> >
> >         /* If it's deflate, and it's got no preset dictionary, then
> >            we can tell zlib to skip the adler32 check. */
> > -       if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
> > +       if (srclen > 2 && !(data_in[1] & 0x20) &&
> >             ((data_in[0] & 0x0f) == Z_DEFLATED) &&
> >             !(((data_in[0]<<8) + data_in[1]) % 31)) {
>
> Why not
>
> #define PRESET_DICT 0x20
>
> instead of obfuscating the code with a magic number ? (Or name it
> differently if it clashes with something else...)
>
>
> Cheers,
>
> Prakash

Not a problem. This patch was just a result of a quick s/PRESET_DICT/0x20/p -  
I'll change the patch so there is a localized PRESET_DICT macro. 

I've attached an updated patch that does just that.

(Mark Adler suggested a second, more involved patch that would put the burdon 
of all the checking that JFFS2 is doing where it belongs, and already is done 
actually, zlib's inflate() )

DRH
 
diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..f4519db 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"

@@ -29,6 +28,13 @@
        */
 #define STREAM_END_SPACE 12

+/*
+ * PRESET_DICT is set in the internal (aka: private) zlib header zutil.h
+ * the value - 0x20 - is defined in RFC 1950, so making a duplicate
+ * definition here to remove this code's dependency on that file is safe.
+ */
+#define PRESET_DICT 0x20
+
 static DEFINE_MUTEX(deflate_mutex);
 static DEFINE_MUTEX(inflate_mutex);
 static z_stream inf_strm, def_strm;

--Boundary-00=_l1hYGwKcrszRlyw
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="remove-jffs2-zutil.h-dependency.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="remove-jffs2-zutil.h-dependency.patch"

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..f4519db 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"
 
@@ -29,6 +28,13 @@
 	*/
 #define STREAM_END_SPACE 12
 
+/*
+ * PRESET_DICT is set in the internal (aka: private) zlib header zutil.h
+ * the value - 0x20 - is defined in RFC 1950, so making a duplicate
+ * definition here to remove this code's dependency on that file is safe.
+ */
+#define PRESET_DICT 0x20
+
 static DEFINE_MUTEX(deflate_mutex);
 static DEFINE_MUTEX(inflate_mutex);
 static z_stream inf_strm, def_strm;

--Boundary-00=_l1hYGwKcrszRlyw--
