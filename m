Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZHFJOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZHFJOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZHFJOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:14:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZHFJOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:14:03 -0400
Message-ID: <4A7A9ED6.8010400@suse.de>
Date: Thu, 06 Aug 2009 18:13:58 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Colin Guthrie <cguthrie@mandriva.org>, Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH 2/3] sound: request char-major-* module aliases for missing
 OSS devices
References: <4A7A9EB3.4010302@kernel.org>
In-Reply-To: <4A7A9EB3.4010302@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Till now missing OSS devices emitted sound-slot/service-* module
alises instead of the standard char-major-* if a missing device number
is opened if soundcore is loaded.  The custom module aliases don't
have any inherent benefit than backward compatibility.

sound-slot/service-* module aliases is scheduled to be removed and to
help the transition this patch makes soundcore emit the standard
module alises along with the custom ones.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 sound/sound_core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: work/sound/sound_core.c
===================================================================
--- work.orig/sound/sound_core.c
+++ work/sound/sound_core.c
@@ -541,6 +541,7 @@ static int soundcore_open(struct inode *
 		new_fops = fops_get(s->unit_fops);
 	if (!new_fops) {
 		spin_unlock(&sound_loader_lock);
+
 		/*
 		 *  Please, don't change this order or code.
 		 *  For ALSA slot means soundcard and OSS emulation code
@@ -550,6 +551,17 @@ static int soundcore_open(struct inode *
 		 */
 		request_module("sound-slot-%i", unit>>4);
 		request_module("sound-service-%i-%i", unit>>4, chain);
+
+		/*
+		 * sound-slot/service-* module aliases are scheduled
+		 * for removal in favor of the standard char-major-*
+		 * module aliases.  For the time being, generate both
+		 * the legacy and standard module aliases to ease
+		 * transition.
+		 */
+		if (request_module("char-major-%d-%d", SOUND_MAJOR, unit) > 0)
+			request_module("char-major-%d", SOUND_MAJOR);
+
 		spin_lock(&sound_loader_lock);
 		s = __look_for_unit(chain, unit);
 		if (s)
