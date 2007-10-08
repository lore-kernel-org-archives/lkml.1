Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbXJHUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbXJHUBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbXJHUBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:01:14 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54424 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXJHUBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:01:13 -0400
Message-ID: <470A8C7D.70303@tiscali.nl>
Date: Mon, 08 Oct 2007 22:01:01 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [patch 08/12] NLM: Fix a circular lock dependency in lockd
References: <20071008180406.052382073@mini.kroah.org> <20071008180629.GI7627@kroah.com>
In-Reply-To: <20071008180629.GI7627@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

@@ -477,10 +479,15 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
 
 	if (block == NULL) {
 		struct file_lock *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+		struct nlm_host	*host;
 
 		if (conf == NULL)
 			return nlm_granted;
-		block = nlmsvc_create_block(rqstp, file, lock, cookie);
+		/* Create host handle for callback */
+		host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len);
+		if (host == NULL)
+			return nlm_lck_denied_nolocks;
+		block = nlmsvc_create_block(rqstp, host, file, lock, cookie);
 		if (block == NULL) {
 			kfree(conf);
 			return nlm_granted;

To be frankly I don't know what this is about, but shouldn't conf be freed if host == NULL?
