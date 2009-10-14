Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZJNHvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZJNHvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbZJNHvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:51:07 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:40181 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbZJNHvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qQfxgGCGRjnWiL/oQEuaNgkAPWmwpQDyNO6iqiVQNCL6ccgiAkAZhy6AfDhgrlhjMM
         TM/Nh1NH6gMwodiElJAth/ux0/14reQkqpB4Wft+2a1PaKAYlNN3obB8qAjmfl2W2oj2
         qreB+zPSTrjmgQPvfZyNs+PhchMuVe+pMFsdM=
Date: Wed, 14 Oct 2009 00:50:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Kosina <jkosina@suse.cz>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20091014075024.GC5318@core.coreip.homeip.net>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de> <20091014045851.GA32413@core.coreip.homeip.net> <20091014071950.GF23248@one.firstfloor.org> <20091014073927.GB5318@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014073927.GB5318@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 12:39:28AM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 14, 2009 at 09:19:50AM +0200, Andi Kleen wrote:
> > > Btw, what kind of keyboard is this? I was playing today but I could not
> > > get my USB keyboards to report release of more than 1 key per report....
> > 
> > The log was with a PS/2<->USB adapter, with a PS/2 keyboard connected
> > to a USB port through it.
> > 
> 
> Hmm, I don't think I have one of those... It is curious beast - we have
> software autorepeat for HID but PS/2 keyboards do autorepeat
> themselves... What will combination do?
> 

Could you please try this incredibly stupid patch?

-- 
Dmitry


Input: autorepeat debug patch

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/input.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/drivers/input/input.c b/drivers/input/input.c
index 6ba676b..77fa3da 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -137,7 +137,7 @@ static void input_repeat_key(unsigned long data)
 	if (test_bit(dev->repeat_key, dev->key) &&
 	    is_event_supported(dev->repeat_key, dev->keybit, KEY_MAX)) {
 
-		input_pass_event(dev, EV_KEY, dev->repeat_key, 2);
+		input_pass_event(dev, EV_KEY, dev->repeat_key, 200);
 
 		if (dev->sync) {
 			/*
@@ -208,7 +208,15 @@ static void input_handle_event(struct input_dev *dev,
 		if (is_event_supported(code, dev->keybit, KEY_MAX) &&
 		    !!test_bit(code, dev->key) != value) {
 
-			if (value != 2) {
+			if (value == 2 || value == 200) {
+				/* autorepeat */
+				if (!test_bit(code, dev->key)) {
+					printk(KERN_ERR "%s autorepeat for released key %d\n",
+						value == 200 ? "software" : "hardware", code);
+					break;
+				}
+				value = 2;
+			} else {
 				__change_bit(code, dev->key);
 				if (value)
 					input_start_autorepeat(dev, code);
