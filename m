Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZKKN3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZKKN3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZKKN3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:29:45 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:36678 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZKKN3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:29:44 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200910291936.14082.rjw@sisk.pl>
	<87my2tnvtu.fsf@tac.ki.iif.hu> <200911111238.22696.rjw@sisk.pl>
Date: Wed, 11 Nov 2009 14:29:10 +0100
In-Reply-To: <200911111238.22696.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 11 Nov 2009 12:38:22 +0100")
Message-ID: <87pr7pi40p.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday 11 November 2009, Ferenc Wagner wrote:
>
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>>> On Thursday 29 October 2009, Ferenc Wagner wrote:
>>>
>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>> 
>>>>> On Wednesday 28 October 2009, Ferenc Wagner wrote:
>>>>> 
>>>>>> 2.6.32-rc5 feels particularly bad, with frequent failures to switch
>>>>>> off the machine after "S|" or freezes after "Snapshotting system".
>>>>>> The former does not cause much trouble in itself, as the machine can
>>>>>> be switched off and resumed all right, but the latter is nasty.
>>>>>> Suspend to RAM works all the time.  The issue is not reproducible,
>>>>>> unfortunately, and the kernel change happened almost together with a
>>>>>> BIOS upgrade.  Yesterday I switched back to 2.6.31 to see whether it
>>>>>> still works stably with the new BIOS.  I'll report back my findings in
>>>>>> a couple of days.
>>>>>
>>>>> OK, thanks.
>>>>>
>>>>> Still, I'm really afraid we won't be able to debug it any further without a
>>>>> reproducible test case.
>>>>
>>>> Can't you perhaps suggest a way forward there?  Or some tricks to create a
>>>> reproducible test case here?
>>>
>>> Well, you can test if the problem is reproducible in the "shutdown" mode of
>>> hibernation.
>> 
>> Well, both failure modes happen with "shutdown" mode as well (the S|
>> freeze with yesterday's git, too), but still not reproducibly.  When
>> s2disk is stuck in "Snapshotting system", the system is not completely
>> dead, it echoes line feeds and Ctrl-C at least (as added to #14504).
>> 
>> I wonder what you did if the issue was reproducible...  Is that totally
>> unapplicable if the problem happens with 10% probability only?  Slow,
>> sure, but until I manage to set up an automated testing bench...
>
> I would try to identify the commit that made the problem appear using git
> bisection.  However, this is really difficult with problems that are not
> reliably reproducible.

Indeed.  I'm thinking about setting up a script, which does nothing but
hibernates the laptop in a loop, and get my router provide a constant
stream of WOL packets to restart it.  If it always freezes in bounded
time that will make bisecting possible, if slow.

> Failing that, I would add some instrumentation to the code to identify the
> exact place where it hangs.

I managed to achieve this with my STR problem, see
http://bugs.freedesktop.org/show_bug.cgi?id=22126#c17, but maybe that
status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
wasn't deep enough, as it got no followup.  How deep should one go to be
useful?

I can probably do so again, if slower; but this case may also be easier
if I can depend on working console output.  Which are the interesting
parts for instrumentation?  Can those parts produce console output to
VGA or netconsole?  Wouldn't switching on ACPI debugging before invoking
s2disk be useful?  Which parts of it (to avoid it spitting out MBs of
useless characters)?

> BTW, did you carry out the /sys/power/pm_test "core" test on the box?

I'm not clear on how to do that with user space suspend.  Simply set it
to "cores" before invoking s2disk?  I already did the test for STR (see
http://bugs.freedesktop.org/show_bug.cgi?id=22126#c3), but will redo
with the current kernel tonight.
-- 
Thanks,
Feri.
