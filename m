Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZBWCz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZBWCz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZBWCzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:55:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZBWCzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:55:49 -0500
Message-ID: <49A21044.40402@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 10:56:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       menage@google.com, containers@lists.linux-foundation.org
Subject: Re: Question for remount
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com> <49A20976.2050301@cn.fujitsu.com>
In-Reply-To: <49A20976.2050301@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> 1. Documentation/cgroups/cgroup.txt says
>>    #mount -oremount,cpuset,ns /dev/cgroup
>>    But this should be
>>    #mount -tcgroup none /dev/cgroup -oremount,cpuset,ns
>>
> 
> I agree. Actually I noticed this long ago.
> 
> Doing this won't remove cpuacct from the cgroup hierarchy:
> # mount -t cgroup -o cpu,cpuacct xxx /mnt
> # mount -o remount,cpu /mnt
> This will get you right:
> # mount [-t cgroup] -o remount,cpu xxx /mnt
> 

How about this patch:

[PATCH] cgroups: fix documentation about remount

This won't remove cpuacct from the mounted hierachy:
 # mount -t cgroup -o cpu,cpuacct xxx /mnt
 # mount -o remount,cpu /mnt

Because for this usage mount(8) will append the new options to the current
options.

And this will get you right:
 # mount [-t cgroup] -o remount,cpu xxx /mnt

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 93feb84..5cbeab2 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -337,8 +337,13 @@ subsystems, type:
 
 To change the set of subsystems bound to a mounted hierarchy, just
 remount with different options:
+# mount -o remount,cpuset,ns hier1 /dev/cgroup
 
-# mount -o remount,cpuset,ns  /dev/cgroup
+Now numtasks is removed from the hierarchy and ns is added.
+
+Note this will add ns to the hierarchy but won't remove numtasks or
+cpuset:
+# mount -o remount,ns /dev/cgroup
 
 Note that changing the set of subsystems is currently only supported
 when the hierarchy consists of a single (root) cgroup. Supporting
-- 
1.5.4.rc3

