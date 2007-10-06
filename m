Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXJFIly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXJFIly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXJFIlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:41:46 -0400
Received: from relay4.usu.ru ([194.226.235.39]:36134 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbXJFIlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:41:44 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 04:41:44 EDT
Message-ID: <4707491B.6060001@ums.usu.ru>
Date: Sat, 06 Oct 2007 14:36:43 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [code] Unlimited partitions, a try
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>	<4706B6A8.2060800@zytor.com> <20071006002919.0b32c8b9@the-village.bc.nu>
In-Reply-To: <20071006002919.0b32c8b9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> This was proposed ages ago. Al Viro vetoed sparse minors and it has been
> stuck this way ever since. If you have > 15 partitions use device mapper
> for it. I'd prefer it fixed but its arguable that device mapper is the
> right way to punt all our partitioning to userspace.
>   

Then please fix support for extended partitions in kpartx (part of 
multipath-tools). Debian has an incomplete patch that does the right 
thing on activation, but not on deactivation of partitions, and has an 
obvious off-by-one in the "kpartx -l /dev/sda" output.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Edited by Alexander E. Patrakov to fix incorrect output of "kpartx -l"
Signed-off-by: Alexander E. Patrakov <patrakov@ums.usu.ru>

--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -387,10 +387,10 @@ main(int argc, char **argv){
 					slices[j].minor = m++;
 
 					start = slices[j].start - slices[k].start;
-					printf("%s%s%d : 0 %lu /dev/dm-%d %lu\n",
+					printf("%s%s%d : 0 %lu %s%s%d %lu\n",
 					       mapname, delim, j+1,
 					       (unsigned long) slices[j].size,
-					       slices[k].minor, start);
+					       mapname, delim, k+1, start);
 					c--;
 				}
 				/* Terminate loop if nothing more to resolve */
@@ -431,7 +431,7 @@ main(int argc, char **argv){
 			break;
 
 		case ADD:
-			for (j=0, c = 0; j<n; j++) {
+			for (j = 0, c = 0; j < n; j++) {
 				if (slices[j].size == 0)
 					continue;
 
@@ -477,6 +477,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
+					unsigned long start;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -487,7 +488,7 @@ main(int argc, char **argv){
 						continue;
 
 					/* Skip all simple slices */
-					if (k < 0)
+					if (slices[j].container == 0)
 						continue;
 
 					/* Check container slice */
@@ -502,10 +503,11 @@ main(int argc, char **argv){
 					}
 					strip_slash(partname);
 
+					start = slices[j].start - slices[k].start;
 					if (safe_sprintf(params, "%d:%d %lu",
 							 slices[k].major,
 							 slices[k].minor,
-							 (unsigned long)slices[j].start)) {
+							 start)) {
 						fprintf(stderr, "params too small\n");
 						exit(1);
 					}
@@ -524,9 +526,12 @@ main(int argc, char **argv){
 						&slices[j].minor);
 
 					if (verbose)
-						printf("add map %s : 0 %lu %s %s\n",
-						       partname, slices[j].size,
-						       DM_TARGET, params);
+						printf("add map %s (%d:%d): 0 %lu %s\n",
+						       partname, 
+						       slices[j].major,
+						       slices[j].minor,
+						       slices[j].size,
+						       params);
 					c--;
 				}
 				/* Terminate loop */


-- 
Alexander E. Patrakov
