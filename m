Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZJaL4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZJaL4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 07:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbZJaL4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 07:56:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:1484 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbZJaL4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 07:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CASB9xxLgAXCJL4LI3R7mClNZ/LHdgXBGq8ZptLxbqENQnpHnY+GnRGB4IQ4uB9lok
         LHpTZUcKT1kh+BPihNNgwY1/R5sgL5OwxNE1fz34HUrXwdeuspROQ8uQlHYZCXGzeswY
         kWBm1H6wuhcN/AJGfadPhJqs/1sTpUpWAsUCY=
Message-ID: <4AEC2601.8030803@tuffmail.co.uk>
Date: Sat, 31 Oct 2009 11:56:49 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: perf-record & perf-report in root directory: can't find binaries
 for symbol resolution
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I ran perf record & report in the root directory, I noticed that
perf couldn't find any binaries.  Both addresses and the actual names of
the binaries were printed as raw hex values:

# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
    14.23%         modprobe       b777ce85  [.] 0x000000b777ce85
                |
                |--9.52%-- 0x804cad2
                |          0x8049b32


Strace showed that perf report was trying to open ".sbin/modprobe".  I
found a one-line fix, which should at least explain my problem:

---------------------------------------------
>From a2eb15237fee2276fc8e388f9e15409ed7caf9e1 Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Fri, 30 Oct 2009 14:12:30 +0000
Subject: [PATCH] perf tools: fix test for whether pathnames can be shortened

The intention is to consider the pair (filename, cwd) and shorten the
filename if it lives under cwd.  E.g. ("/src/foo", "/src") -> "./foo".

Make the test more specific to exclude these unintended consequences:

    ("/src/foo", "/") -> ".src/foo"
    ("/src/foo", "/s") -> ".rc/foo"

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 tools/perf/util/map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 804e023..bd17703 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -31,7 +31,7 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 		if (cwd) {
 			int n = strcommon(filename, cwd, cwdlen);
 
-			if (n == cwdlen) {
+			if (n == cwdlen && filename[n] == '/') {
 				snprintf(newfilename, sizeof(newfilename),
 					 ".%s", filename + n);
 				filename = newfilename;
-- 
1.6.3.2



