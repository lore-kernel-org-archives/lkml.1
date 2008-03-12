Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYCLKrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYCLKrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYCLKrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:47:41 -0400
Received: from sacred.ru ([62.205.161.221]:43289 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYCLKrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:47:40 -0400
Message-ID: <47D7AF90.7060301@openvz.org>
Date: Wed, 12 Mar 2008 13:25:20 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add a document describing the resource counter abstraction
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 12 Mar 2008 13:25:20 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource counter is supposed to facilitate the resource accounting
of arbitrary resource (and it already does this for memory controller).

However, it is about to be used in other resources controllers (swap,
kernel memory, networking, etc), so provide a doc describing how to
work with it.  This will eliminate all the possible future duplications
in the appropriate controllers' docs.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/Documentation/controllers/resource_counter.txt b/Documentation/controllers/resource_counter.txt
new file mode 100644
index 0000000..99f16c6
--- /dev/null
+++ b/Documentation/controllers/resource_counter.txt
@@ -0,0 +1,173 @@
+
+		The Resource Counter
+
+The resource counter, declared at include/linux/res_counter.h
+is supposed to facilitate the resource management by controllers
+by providing common stuff for accounting.
+
+This "stuff" includes the res_counter structure and routines
+to work with it.
+
+
+
+1. Crucial parts of the res_counter structure
+
+ a. unsigned long long usage
+
+ 	The usage value shows the amount of a resource that is consumed
+	by a group at a given time. The units of measurement should be
+	determined by the controller, that uses this counter. E.g. it can
+	be bytes, items or any other unit the controller operates on.
+
+ b. unsigned long long max_usage
+
+ 	The maximal value of the usage over the time.
+
+ 	This value is useful when gathering a statistical information about
+	the particular group, as it shows the actual resource requirements
+	for a particular group, not just some usage snapshot.
+
+ c. unsigned long long limit
+
+ 	The maximal allowed amount of resource to consume by the group. In
+	case the group requests for more resources, so that the usage value
+	would exceed the limit, the resource allocation is rejected (see
+	the next section)
+
+ d. unsigned long long failcnt
+
+ 	The failcnt stands for "failures counter". This is the number of
+	resource allocation attempts, that failed.
+
+ c. spinlock_t lock
+
+ 	Protects changes of the above values.
+
+
+
+2. Basic accounting routines
+
+ a. void res_counter_init(struct res_counter *rc)
+
+ 	Initializes the resource counter. As usual, should be the first
+	routine called for a new counter.
+
+ b. int res_counter_charge[_locked]
+			(struct res_counter *rc, unsigned long val)
+
+	When a resource is about to be allocated it has to be accounted
+	with the appropriate resource counter (controller should determine
+	which one to use by its own). This operation is called "charging".
+
+ c. void res_counter_uncharge[_locked]
+			(struct res_counter *rc, unsigned long val)
+
+	When a resource is released (freed) is should be de-accounted
+	from the resource counter it was accounted to.  This is called
+	"uncharging".
+
+    The _locked routines imply that the res_counter->lock is taken.
+
+
+ 2.1 Other accounting routines
+
+    There are more routines that may help you with the common need, like
+    checking whether the limit is reached or re-setting the max_usage
+    value. They are all declared in include/linux/res_counter.h
+
+
+
+3. Analyzing the resource counter registrations
+
+ a. If the failcnt value constantly grows this means, that the counter's
+    limit is too tight. Either the group is misbehaving and consumes too
+    many resources, or the configuration is not suitable for the group
+    and the limit should be increased.
+
+ b. The max_usage value can be used to quickly tune the group. One may
+    set the limits to maximal values and either load the container with
+    a common patterns or leave one for a while. After this the max_usage
+    value shows the amount of memory the container would require during
+    its common activity.
+
+    Setting the limit a bit above this value gives a pretty good
+    configuration, that works in most of the cases.
+
+ c. If the max_usage is much less than the limit, but the failcnt value
+    is growing, then the group tries to allocate a big chunk of resource
+    at once.
+
+ d. If the max_usage is much less than the limit, but the failcnt value
+    is 0, then this group is given too high limit, that it does not
+    require. It is better to lower the limit a bit leaving more resource
+    for other groups.
+
+
+
+4. Communication with the control groups subsystem (cgroups)
+
+All the resource controllers, that are using cgroups and resource
+counters should provide files to work with the resource counter fields.
+They are recommended to adhere to the following rules:
+
+ a. File names
+
+ 	Field name	File name
+	---------------------------------------------------
+	usage		usage_in_<unit_of_measurement>
+	max_usage	max_usage_in_<unit_of_measurement>
+	limit		limit_in_<unit_of_measurement>
+	failcnt		failcnt
+	lock		no file :)
+
+ b. Reading from file should show the according field value in the 
+    appropriate format.
+
+ c. Writing to file
+
+ 	Field		Expected behavior
+	----------------------------------
+	usage		prohibited
+	max_usage	reset to usage
+	limit		set the limit
+	failcnt		reset to zero
+
+
+
+5. Usage example
+
+ a. Declare a task group (take a look at cgroups subsystem for this) and
+    fold a res_counter into it
+
+	struct my_group {
+		struct res_counter res;
+
+		<other fields>
+	}
+
+ b. Put hooks in resource allocation/release paths
+
+ 	int alloc_something(...)
+	{
+		if (res_counter_charge(res_counter_ptr, amount) < 0)
+			return -ENOMEM;
+
+		<allocate the resource and return to the caller>
+	}
+
+	void release_something(...)
+	{
+		res_counter_uncharge(res_counter_ptr, amount);
+
+		<release the resource>
+	}
+
+    In order to keep the usage value self-consistent, both the
+    "res_counter_ptr" and the "amount" in release_something() should be
+    the same as they were in the alloc_something() when the releasing
+    resource was allocated.
+
+ c. Provide the way to read res_counter values and set them (the cgroups
+    still can help with it).
+
+ c. Compile and run :)
diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index df8085a..629d0ea 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -9,6 +9,8 @@
  *
  * Author: Pavel Emelianov <xemul@openvz.org>
  *
+ * See Documentation/controllers/resource_counter.txt for more
+ * info about what this counter is.
  */
 
 #include <linux/cgroup.h>
