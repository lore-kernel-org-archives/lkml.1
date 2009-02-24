Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZBXBdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZBXBdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZBXBdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:33:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZBXBda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:33:30 -0500
Message-ID: <49A34E72.1040609@cn.fujitsu.com>
Date: Tue, 24 Feb 2009 09:33:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: Re: Question for remount
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>	<6599ad830902200822u6d453340me718bacac3925040@mail.gmail.com>	<d7928a87d8c1bf661e3a3b64db9fa988.squirrel@webmail-b.css.fujitsu.com>	<49A20ACE.7020309@cn.fujitsu.com> <20090224085724.4cc1b3b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090224085724.4cc1b3b2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 23 Feb 2009 10:32:46 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> Paul Menage さんは書きました：
>>>> On Fri, Feb 20, 2009 at 2:02 AM, KAMEZAWA Hiroyuki
>>>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>>> 2. /proc/mounts information of release_agent should be updated....
>>>>>   when it's overwritten directly.
>>>> Yes, definitely. But shouldn't that happen already?
>>>> cgroup_show_options() reports the current value of
>>>> root->release_agent_path in /proc/mounts. Is it possible that mount is
>>>> actually storing/retrieving this information in /etc/mtab, which
>>>> doesn't get updated?
>>>>
>>> Ah, you're right. /proc/mounts is updated but /etc/mtab is not updated.
>>> Hmm..from man mount(1), /etc/mtab is not synchronized with /proc/mounts.
>>> Do we need to allow release_agent override at remount ?
>>>
>> Since we've allowed this behavior, I think we shouldn't disallow it to
>> supprise users?
>>
> In a bit different stroy, it already surprises a user (me).
> for example)
> 

I think what may surprise people is the following mount will append opts
to the original opts.

> #mount -t cgroup none /cgroups -ocpu,release_agent=hogehoge
> #mount -oremount,cpuacct /cgroups,release_agent=xxxx
> => remount fails. because the option "release_agent" appears twice.
> 
> #mount -t cgroup none /cgroups -ocpu,release_agent=hogehoge
> #mount -t cgroup none /cgroups -oremount,cpuacct /cgroups,release_agent=xxxx
> => remount success.
> 
> At least, updating documentation to notice this is necessary I think.
> 

How about this:

[PATCH] cgroups: more documentation for remount and release_agent

This won't remove cpuacct from the mounted hierachy:
 # mount -t cgroup -o cpu,cpuacct xxx /mnt
 # mount -o remount,cpu /mnt

Because for this usage mount(8) will append the new options to the original
options.

And this will get you right:
 # mount [-t cgroup] -o remount,cpu xxx /mnt

Also document how to specify and change release_agent.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 93feb84..824277d 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -337,8 +337,19 @@ subsystems, type:
 
 To change the set of subsystems bound to a mounted hierarchy, just
 remount with different options:
+# mount -o remount,cpuset,ns hier1 /dev/cgroup
 
-# mount -o remount,cpuset,ns  /dev/cgroup
+Now numtasks is removed from the hierarchy and ns is added.
+
+Note this will add ns to the hierarchy but won't remove numtasks or
+cpuset:
+# mount -o remount,ns /dev/cgroup
+
+To Specify a hierarchy's release_agent:
+# mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
+  xxx /dev/cgroup
+
+Note that specifying 'release_agent' more than once will return failure.
 
 Note that changing the set of subsystems is currently only supported
 when the hierarchy consists of a single (root) cgroup. Supporting
@@ -349,6 +360,11 @@ Then under /dev/cgroup you can find a tree that corresponds to the
 tree of the cgroups in the system. For instance, /dev/cgroup
 is the cgroup that holds the whole system.
 
+If you want to change the value of release_agent:
+# echo "/sbin/new_release_agent" > /dev/cgroup/release_agent
+
+It can also be changed via remount.
+
 If you want to create a new cgroup under /dev/cgroup:
 # cd /dev/cgroup
 # mkdir my_cgroup

