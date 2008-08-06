Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbYHFUgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbYHFUgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbYHFUf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:35:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:58500 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbYHFUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QOlGY+brazHup4rN9g6/HN22O7ladVIHITH0am89gquyUs4GkgGBaS67kVus0R6AdK
         cnfUyz5T+p9bgwQr+Bu0hYnE1lvJqdYdWUzhk4IdZzY1C9DGZ5SC0OahxLxVcIRj5TQJ
         tQjO0ET5Dpb5avCE3iHiq26cpxqwFL1967WGk=
Message-ID: <489A0B27.80604@gmail.com>
Date: Wed, 06 Aug 2008 17:35:51 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Weird behaviour on /proc/stat
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've executed the following code on a intel core 2 quad (linux 2.6.21.5):

for (( x=0; x < 1800; x = x+1 )); do
        head -n5 /proc/stat |
        awk '{ print $2+$3+$4+$5+$6+$7+$8+$9 }' |
        awk 'BEGIN { x=0 } { if (NR == 1) y=$0; else x=x+$1; } END {
print y, x }' |
        awk '{ print $0, $1-$2 }' >> values
        sleep 1;
done

My expectation was that the values file would have only 0s on the second
field. It didn't happen. Actually, it was always a value greater than 0.
So I went to the kernel code. The utilization is summed up here:

	http://lxr.linux.no/linux+v2.6.21.5/fs/proc/proc_misc.c#L463

Reading that file, if anything the sum of all the cpuX fields should be
greater than the cpu line. After all, it happens later and, if
information regarding the utilization is updated during the generation
of the output, then the cpuX lines should have a greater value.

I also noted that on
	http://lxr.linux.no/linux+v2.6.21.5/fs/proc/proc_misc.c#L463
for_each_possible_cpu is used. While on
	http://lxr.linux.no/linux+v2.6.21.5/fs/proc/proc_misc.c#L487
for_each_online_cpu is used. All the cores on the system are online, so
where could be the extra utilization that's being added to the first
line result?

I wish I had a machine with 4 cores which I could test changes on that
code, so I could investigate things a little further. But the only
machine I can change the kernel is my home computer which has only one
core  :(.
