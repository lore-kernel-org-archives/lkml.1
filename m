Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbYGBJ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbYGBJ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762917AbYGBJ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:58:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762730AbYGBJ6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:58:19 -0400
Message-ID: <486B5073.9030207@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 17:54:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: miaox@cn.fujitsu.com, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
References: <4843AFC9.7000100@cn.fujitsu.com> <20080702021908.81a5f1bb.akpm@linux-foundation.org> <486B4D52.80402@cn.fujitsu.com>
In-Reply-To: <486B4D52.80402@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> kernel/cpuset.c: In function 'cpuset_write_resmask':
>> kernel/cpuset.c:1374: warning: passing argument 2 of 'update_nodemask' discards qualifiers from pointer target type
>>
>> Did you not get this warning also?
>>
>> I don't know how to fix it.  cftype.write_string() requires a const
>> char* in the third arg, but we then go on to call update_nodemask(),
>> which does a strstrip() on this allegedly-const char array.
>>
> 
> That strstrip() should be removed. because cgroup_write_string() already strstrip()ed
> the buffer. Paul M's original patch removed that 2 strstrip()s in cpuset.c.
> 

Here is the patch:

--- linux-2.6.26-rc7/kernel/cpuset.c.bak	2008-07-02 17:53:07.000000000 +0800
+++ linux-2.6.26-rc7/kernel/cpuset.c	2008-07-02 17:53:23.000000000 +0800
@@ -1011,7 +1011,7 @@ done:
  * lock each such tasks mm->mmap_sem, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
  */
-static int update_nodemask(struct cpuset *cs, char *buf)
+static int update_nodemask(struct cpuset *cs, const char *buf)
 {
 	struct cpuset trialcs;
 	nodemask_t oldmem;
@@ -1032,7 +1032,6 @@ static int update_nodemask(struct cpuset
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have memory.
 	 */
-	buf = strstrip(buf);
 	if (!*buf) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {


>> Taking a copy of the string in update_nodemask() would fix things, but
>> that's pretty lame.
>>
