Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYBWEfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYBWEfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYBWEfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:35:02 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:26403 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYBWEe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:34:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wFwNbmy5hQQdORbmORTffEYPeyxn+W/d5+Bu6o45Az++kUX2/3cOcI44mgzguCunXJSZTe4d8SgYx2djS6kzS72l5pCEYa/cJ/bl7wTebuSDBaqtgq8gYwJJXEp4nVVBhH9qeY8yAjVLXrr7Qc9L1O4uWPhLDctuBH+wa1r5oQc=
Message-ID: <97a0a9ac0802222034m125b43c1hda1e24f04ab0ebd3@mail.gmail.com>
Date: Fri, 22 Feb 2008 21:34:58 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
In-Reply-To: <200802221507.15871.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <20080220193709.GD21139@uranus.ravnborg.org>
	 <97a0a9ac0802212024w62dbfb03ye62c51744e853b36@mail.gmail.com>
	 <200802221507.15871.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 7:07 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 22 February 2008 05:24:32 Gordon Farquharson wrote:
>  > On Wed, Feb 20, 2008 at 12:37 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>  >
>  > >  Option 1) is the worst of the three as that can cost
>  > >  of many hours bug-hunting.
>  > >  Option 3) may seem optimal but I do not like to add more
>  > >  complexity to this part of the build. And really I do not
>  > >  know a reliable way to detech when we do cross builds anyway.
>  > >
>  > >  Leaving us with option 2) that is simple, strighforward and harmless.
>  >
>  > Are you willing to sign off on and commit the patch?
>
>  Only with a big fat comment added that the alignment is only needed
>  because of a broken sanity check in file2alias.c.

How about this?

---

Align the members of the SSB device structure to a 32 bit boundary so
that the b43 driver can be built for arm using a cross compiler. This
change is required so that the test in scripts/mod/file2alias.c that
checks that the size of the device ID type against the size of the
section in the object file succeeds (see
http://lkml.org/lkml/2008/2/18/481 for discussion).

Signed-off-by: Gordon Farquharson <gordonfarquharson@gmail.com>

---

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 139d49d..93083ad 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -351,7 +351,9 @@ struct sdio_device_id {
 struct ssb_device_id {
        __u16   vendor;
        __u16   coreid;
-       __u8    revision;
+       /* Explicit padding to support cross-compilation. */
+       __u8    revision
+               __attribute__((aligned(sizeof(__u32))));
 };
 #define SSB_DEVICE(_vendor, _coreid, _revision)  \
        { .vendor = _vendor, .coreid = _coreid, .revision = _revision, }

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
