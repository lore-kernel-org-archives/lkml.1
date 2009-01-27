Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZA0UHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZA0UHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZA0UHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:07:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:31173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZA0UHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,334,1231142400"; 
   d="scan'208";a="381866253"
Message-ID: <497F6963.6060701@intel.com>
Date: Tue, 27 Jan 2009 12:06:59 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: powertop ml <power@bughost.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, srostedt@redhat.com
Subject: [ANNOUNCE] sreadahead-1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2009 20:07:00.0097 (UTC) FILETIME=[D0229710:01C980BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All,

we're happy to announce a major rewrite of sreadahead, and the release of version
1.0. This is a significant improvement in the way sreadahead works:

* sreadahead now will work on any filesystem;

  Sreadahead used to use an ioctl to retreive inserted timestamps from ext3
  inodes. This patch is now replaced with a generic open() syscall tracer,
  which will work on all filesystems.

* pack file generation is now integrated entirely in a single binary, and
  automatically done if the pack file is missing;

  Sreadahead is now a single-binary two-purpose program that either reads in
  the content needed, or generates this content. This reduces the chance that
  sreadahead is called incorrectly, but also makes installation a lot easier.
  Sreadahead can now be added to the boot system by inserting a single line
  in a startup script.

* pack file generation is now significantly faster than the old method;

  Sreadahead now uses a kernel tracer which provides with a sort-by-use list of
  all files opened. This removes the need for a special script to discover
  which files were opened at boot. This list is sorted and filtered in C
  code inside sreadahead which proves much faster. The old method took
  multiple seconds. New method sorts/filters 10k+ open trace calls in 0.16s
  on a regular desktop.

* sreadahead now accounts for kernel read_ahead_kb, reducing data read
  at boot time;

  While sreadahead reads "used" data into memory, the kernel reports more
  memory in use than actually used due to the in-kernel readahead function.
  In order to read significantly less data, sreadahead temporarily reduces
  this amount, saving significant amount of total IO time. This saves as
  much as 8 out of 64Mb on a regular fedora core installation.


Sreadahead still depends on a kernel patch (posted in a followup). This patch
implements a global kernel tracer for sys_open() syscalls. The choice was made to
use this method since userland tracing is slow, cumbersome (have to attach to
every process running), and hard to implement for system-wide tracing (we don't
care about which process is doing something). A kernel tracer is extremely
efficient and added bonus is that we can leave the trace in memory until we
actually need to process it.

sreadahead-1.0 can be downloaded from it's google code project page here:

  http://sreadahead.googlecode.com/


Regards,

Auke
