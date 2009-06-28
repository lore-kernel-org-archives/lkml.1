Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZF1MVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZF1MVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZF1MVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:21:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZF1MVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:21:41 -0400
Message-ID: <4A47603D.40205@kernel.org>
Date: Sun, 28 Jun 2009 21:21:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, max@stro.at,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] alpha: fix percpu build breakage
References: <20090625090842.GA17936@stro.at> <20090625115423.6a31b49c.akpm@linux-foundation.org> <4A4419AA.2040400@kernel.org> <20090626124705.GA25147@jurassic.park.msu.ru> <20090626115746.09314757.akpm@linux-foundation.org> <20090626122152.e124254b.akpm@linux-foundation.org> <4A46BE34.7040806@kernel.org> <20090628113940.GA11836@jurassic.park.msu.ru>
In-Reply-To: <20090628113940.GA11836@jurassic.park.msu.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 28 Jun 2009 12:21:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ivan.

Ivan Kokshaysky wrote:
> As for upcoming percpu patchset, can we similarly move the __weak attribute
> to PER_CPU_DEF_ATTRIBUTES? I don't feel really comfortable with an
> "extern __weak" combination - it may not work with future compilers...

Oh... the newest incarnation looks like the following.

#if defined(ARCH_NEEDS_WEAK_PER_CPU) || defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
#define DECLARE_PER_CPU_SECTION(type, name, sec)			\
	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
	extern __PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name

#define DEFINE_PER_CPU_SECTION(type, name, sec)				\
	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
	__PCPU_DUMMY_ATTRS char __pcpu_unique_##name;			\
	__PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
#else
#define DECLARE_PER_CPU_SECTION(type, name, sec)			\
	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name

#define DEFINE_PER_CPU_SECTION(type, name, sec)				\
	__PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
#endif

So, I can simply drop __weak from the declaration like the following.
Looks good?

 include/linux/percpu-defs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index cf32838..9b7a53c 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -56,7 +56,7 @@
  */
 #define DECLARE_PER_CPU_SECTION(type, name, sec)			\
 	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
-	extern __PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
+	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
 	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\

-- 
tejun
