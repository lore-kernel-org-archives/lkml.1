Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYGaOJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYGaOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYGaOJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:09:17 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:59720 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYGaOJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P0hWsbCgLnr2sbAAX0gW0GZ4fpEkbLGeu2qLtjJ68aOaLV2O+iGVi5YUoWnUl68Xp0
         E/n3H5L7YgudjhIxb8roM4DXNOOqzE/aVSWM5m19pxwtqpIB2SCuDD6d4tWS1I1A5MJa
         VCv4HEsHBAiSxBOO7GDDMNdVpIkfrpbyjPSb0=
Date: Thu, 31 Jul 2008 10:07:09 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080731140708.GA11229@core.corenet.prv>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080730231029.9818953c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730231029.9818953c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 11:10:29PM -0700, Andrew Morton wrote:
> On Wed, 30 Jul 2008 17:06:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> The X server broke on my FC8 t61p thinkpad.  Mainline is OK.
> 
> Various information is at http://userweb.kernel.org/~akpm/mo/
> 
> I'm suspecting the input layer - my synaptics device seems to have
> disappeared?  See http://userweb.kernel.org/~akpm/mo/Xorg-log-diff.txt
> 

I think this patch should help with Synaptics:

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] Fix crash on kernels with extended keymap space

The len argument of EVIOCGBIT(ev,len) is the size of the receiving
buffer in bytes, not maximim number of bits to retrieve.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 eventcomm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/eventcomm.c b/eventcomm.c
index e3257cd..2d0a347 100644
--- a/eventcomm.c
+++ b/eventcomm.c
@@ -89,7 +89,7 @@ event_query_is_touchpad(int fd)
 
     /* Check for ABS_X, ABS_Y, ABS_PRESSURE and BTN_TOOL_FINGER */
 
-    SYSCALL(ret = ioctl(fd, EVIOCGBIT(0, EV_MAX), evbits));
+    SYSCALL(ret = ioctl(fd, EVIOCGBIT(0, sizeof(evbits)), evbits));
     if (ret < 0)
 	return FALSE;
     if (!TEST_BIT(EV_SYN, evbits) ||
@@ -97,7 +97,7 @@ event_query_is_touchpad(int fd)
 	!TEST_BIT(EV_KEY, evbits))
 	return FALSE;
 
-    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_ABS, KEY_MAX), evbits));
+    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_ABS, sizeof(evbits)), evbits));
     if (ret < 0)
 	return FALSE;
     if (!TEST_BIT(ABS_X, evbits) ||
@@ -105,7 +105,7 @@ event_query_is_touchpad(int fd)
 	!TEST_BIT(ABS_PRESSURE, evbits))
 	return FALSE;
 
-    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_KEY, KEY_MAX), evbits));
+    SYSCALL(ret = ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(evbits)), evbits));
     if (ret < 0)
 	return FALSE;
     if (!TEST_BIT(BTN_TOOL_FINGER, evbits))
-- 
1.5.5.1

