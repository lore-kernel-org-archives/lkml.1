Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbZJIPbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbZJIPbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbZJIPbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:31:11 -0400
Received: from xenotime.net ([72.52.64.118]:34336 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933466AbZJIPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:31:09 -0400
Date: Fri, 9 Oct 2009 08:30:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jiri Slaby <jirislaby@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [was: mmotm 2009-10-09-01-07 uploaded]
Message-Id: <20091009083028.61f44133.rdunlap@xenotime.net>
In-Reply-To: <4ACF09D7.9030901@gmail.com>
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
	<4ACF09D7.9030901@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Oct 2009 12:00:55 +0200 Jiri Slaby wrote:

> On 10/09/2009 10:07 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-10-09-01-07 has been uploaded to
> 
> Hi, build fails with:
> ERROR: "cpufreq_get" [arch/x86/kvm/kvm.ko] undefined!
> because of
> CONFIG_KVM=m
> ...
> # CONFIG_CPU_FREQ is not set
> 
> Should cpufreq_get be defined as inline return 0 the same as
> cpufreq_quick_get on !CONFIG_CPU_FREQ?

I submitted a patch for that several days ago, against
linux-next-20091006.  (below again)

---
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_CPU_FREQ is disabled, cpufreq_get() needs a stub.
Used by kvm (although it looks like a bit of the kvm code could
be omitted when CONFIG_CPU_FREQ is disabled).

arch/x86/built-in.o: In function `kvm_arch_init':
(.text+0x10de7): undefined reference to `cpufreq_get'
 
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Eric Paris <eparis@redhat.com>
---
 include/linux/cpufreq.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-next-20091006.orig/include/linux/cpufreq.h
+++ linux-next-20091006/include/linux/cpufreq.h
@@ -291,8 +291,15 @@ struct global_attr {
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 
+#ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
 unsigned int cpufreq_get(unsigned int cpu);
+#else
+static inline unsigned int cpufreq_get(unsigned int cpu)
+{
+	return 0;
+}
+#endif
 
 /* query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it */
 #ifdef CONFIG_CPU_FREQ
