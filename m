Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117Ab0AEIkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0AEIkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888Ab0AEIka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:40:30 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:52107 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0AEIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:40:30 -0500
Date: Tue, 5 Jan 2010 09:40:27 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: kprobes: get rid of distinct type warning
Message-ID: <20100105084027.GA5480@osiris.boeblingen.de.ibm.com>
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
 <20091230132945.f32f49fd.akpm@linux-foundation.org>
 <20100104155702.GB5671@osiris.boeblingen.de.ibm.com>
 <201001050915.41334.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001050915.41334.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:15:41AM +1030, Rusty Russell wrote:
> On Tue, 5 Jan 2010 02:27:02 am Heiko Carstens wrote:
> > On Wed, Dec 30, 2009 at 01:29:45PM -0800, Andrew Morton wrote:
> > > The num_*() "functions" return unsigned on SMP and int on UP.  This is
> > > wrong.
> > > 
> > > The cpu_*() "functions" got lucky and return int in both cases.
> > > 
> > > Personally I think it's neatest if a quantity which can never be
> > > negative is held in an unsigned type.  Than includes anything starting
> > > with "num".  But for expediency's sake we could live with making these
> > > things consistently return "int".
> > > 
> > > Alas, changing those four num_*() "functions" to return int on SMP is a
> > > pretty wide-reaching change and will probably expose warts.
> > 
> > Looks like there are quite a lot of num_* function usages in the kernel.
> > Some seem to assume they return an int some assume an unsigned int.
> > Don't know if it's worth changing anything here.
> > Maybe Rusty has an opinion.
> 
> If we have to go one way or the other, go with unsigned.
> 
> What does such a patch look like?

Something like this, doesn't even trigger new warnings on an !SMP defconfig
build:

Subject: [PATCH] cpumask: let num_*_cpus() function always return unsigned values

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Dependent on CONFIG_SMP the num_*_cpus() functions return unsigned or
signed values.
Let them always return unsigned values to avoid strange casts.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/cpumask.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -90,10 +90,10 @@ extern const struct cpumask *const cpu_a
 #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
 #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
 #else
-#define num_online_cpus()	1
-#define num_possible_cpus()	1
-#define num_present_cpus()	1
-#define num_active_cpus()	1
+#define num_online_cpus()	1U
+#define num_possible_cpus()	1U
+#define num_present_cpus()	1U
+#define num_active_cpus()	1U
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
