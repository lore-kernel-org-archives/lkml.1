Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZHZTiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZHZTiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZHZTiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:38:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbZHZTiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:38:02 -0400
Date: Wed, 26 Aug 2009 12:36:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: zajec5@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-acpi@vger.kernel.org,
       kernel-testers@vger.kernel.org, torvalds@linux-foundation.org,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Message-Id: <20090826123647.e60d9555.akpm@linux-foundation.org>
In-Reply-To: <200908261833.37310.elendil@planet.nl>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
	<b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
	<20090826075337.4230d82c.akpm@linux-foundation.org>
	<200908261833.37310.elendil@planet.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 18:33:34 +0200
Frans Pop <elendil@planet.nl> wrote:

> (Dropped unrelated CCs.)
> 
> Andrew Morton wrote:
> > I'm not seeing any linux-acpi emails from Len since August 14.
> > 
> > So I merged this patch and shall send it along with
> > 
> > thermal_sys-check-get_temp-return-value.patch
> > acpi-dont-call-acpi_processor_init-if-acpi-is-disabled.patch
> 
> Thanks for that Andrew. Could you please do the same for my patches in
> http://bugzilla.kernel.org/show_bug.cgi?id=13389 (or
> http://lkml.org/lkml/2009/8/17/169)?
> 
> That BR is on the regression list for 2.6.30. The patches apply cleanly to 
> current mainline.
> 

OK, shall do, thanks.



These patches make rather a big mess in linux-next.

Rusty's strangely-named patch:

commit 6949d7cbb26476cbf1ee7b45ac74faacc9eb7cdf
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Thu Aug 13 10:26:38 2009 +1000
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Thu Aug 13 10:26:38 2009 +1000

    misc:work_on_cpu-acpi

is now in the acpi tree.  It changes the throttling code so that
set/get_throttling is performed via smp_call_function_single() rather
than via cpumask fiddling.

So in my tree I reworked it so that the new `force' arg gets passed
through appropriately.  It compiles cleanly but I'd suggest that Len
simply drop "misc:work_on_cpu-acpi" and we send it back to Rusty for
some rechecking (sorry).

Rusty/Len: please work out why the title for that patch went silly.

Rusty, please self-administer smackings for

		struct set_throttling_info sti
			= { pr, p_throttling, t_state.target_state };

these things always start out simple and end up not-simple, so some poor
schmuck has to clean them up so stuff doesn't break.

		struct set_throttling_info sti = {
			.pr = pr,
			.p_throttling = p_throttling,
			.target_state = t_state.target_state,
			.force = force
		};

is better!


My linux-next repair job:

 drivers/acpi/processor_throttling.c |   39 +++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~linux-next-fixup drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~linux-next-fixup
+++ a/drivers/acpi/processor_throttling.c
@@ -1015,10 +1015,25 @@ static int acpi_processor_set_throttling
 	return 0;
 }
 
+struct set_throttling_info {
+	struct acpi_processor *pr;
+	struct acpi_processor_throttling *p_throttling;
+	int target_state;
+	bool force;
+	int ret;
+};
+
+static void set_throttling(void *_sti)
+{
+	struct set_throttling_info *s = _sti;
+
+	s->ret = s->p_throttling->acpi_processor_set_throttling(s->pr,
+						s->target_state, s->force);
+}
+
 int acpi_processor_set_throttling(struct acpi_processor *pr,
 						int state, bool force)
 {
-	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1059,10 +1074,13 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		/* FIXME: use work_on_cpu() */
-		set_cpus_allowed_ptr(current, cpumask_of(pr->id));
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state, force);
+		struct set_throttling_info sti = {
+			.pr = pr,
+			.p_throttling = p_throttling,
+			.target_state = t_state.target_state,
+			.force = force };
+		smp_call_function_single(pr->id, set_throttling, &sti, 1);
+		ret = sti.ret;
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1093,11 +1111,12 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			/* FIXME: use work_on_cpu() */
-			set_cpus_allowed_ptr(current, cpumask_of(i));
-			ret = match_pr->throttling.
-				acpi_processor_set_throttling(
-				match_pr, t_state.target_state, force);
+			sti.pr = match_pr;
+			sti.p_throttling = &match_pr->throttling;
+			sti.target_state = t_state.target_state;
+			sti.force = force;
+			smp_call_function_single(i, set_throttling, &sti, 1);
+			ret = sti.ret;
 		}
 	}
 	/*
_

