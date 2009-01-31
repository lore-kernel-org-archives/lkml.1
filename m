Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZAaDOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZAaDOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbZAaCr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:57 -0500
Received: from kroah.org ([198.145.64.141]:55720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757453AbZAaCru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:50 -0500
Date: Fri, 30 Jan 2009 18:45:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 43/43] relay: fix lock imbalance in relay_late_setup_files
Message-ID: <20090131024503.GR12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="relay-fix-lock-imbalance-in-relay_late_setup_files.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit b786c6a98ef6fa81114ba7b9fbfc0d67060775e3 upstream.

One fail path in relay_late_setup_files() omits
mutex_unlock(&relay_channels_mutex);
Add it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -663,8 +663,10 @@ int relay_late_setup_files(struct rchan *chan,
 
 	mutex_lock(&relay_channels_mutex);
 	/* Is chan already set up? */
-	if (unlikely(chan->has_base_filename))
+	if (unlikely(chan->has_base_filename)) {
+		mutex_unlock(&relay_channels_mutex);
 		return -EEXIST;
+	}
 	chan->has_base_filename = 1;
 	chan->parent = parent;
 	curr_cpu = get_cpu();

