Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZBDQtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZBDQtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZBDQtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:49:05 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:55022 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZBDQtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:49:02 -0500
Message-ID: <4989C6F1.3080900@linux.vnet.ibm.com>
Date: Wed, 04 Feb 2009 17:48:49 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_W?= =?ISO-8859-1?Q?eisbecker?= 
	<fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <49883CD7.2060602@linux.vnet.ibm.com> <20090203153139.GI29046@elte.hu>
In-Reply-To: <20090203153139.GI29046@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>> Enable the use of GCC's coverage testing tool gcov [1] with the Linux
>> kernel. gcov may be useful for:
> 
> Nice tool - with one general observation: i'd really prefer if this was 
> properly integrated with ftrace.

I've tried to read up on ftrace and here's what I understood ftrace and
gcov have in common:

- works by inserting probes
- probes gather information when called
- data gathered is presented to user space

As for differences:

ftrace:
- traces function calls
- probing code is provided by the kernel
- presents textual data in a single file
- can enable/disable tracing as a whole or per function
- presents controls to choose a single tracer to be active

gcov:
- traces basic block transitions
- probing code is provided by gcc
- data is presented as binary file + symbolic link per compiled object
  file (including directory structure)
- probing code cannot be disabled, only data can be reset

> In particular the per object file controls are nice - those might be useful 
> to seed ftrace filters as well.

If I understand you correctly, you want to be able to enable/disable
tracing per compiled object file, possibly also choose active tracers
per file. The problem I see with this approach is that with gcov,
controls for a file are created when the gcc generated constructor
function for that file is called. They also have preset names (.gcda
and .gcno files).

I don't think it's feasible to enable gcov compile flags for the entire
kernel when only a non-gcov tracer needs to be enabled. So for that, a
new mechanism is needed which registers all object files. In can imagine
that such a mechanism may be installed using some kbuild magic, but then
there's still no guarantee that controls are provided for the same set
of files that are registered with the gcov tracer.

> So there's good synergy possible and we should reach that synergy before 
> this goes upstream instead of putting it into a separate debugfs position 
> with incompatible flags and concepts. Especially since user-space tools will 
> pick up the gcov data so this gets hardcoded compatibility-wise very quickly 
> and changing it after the fact will be harder.

>From what I've understood about the ftrace mechanism, its currently far
from the point where another tracing mechanism based on a substantially
different design approach can be integrated without a major interface
rework.

As far as user-space tools are concerned - the gcov-kernel support is
designed to be used with the gcov tool (which has been around for some
time already). The only other tool which I know of that uses the
data provided by the gcov-kernel support is lcov (which is also an
established tool). These tools are there already, so I don't see a need
to hurry with merging gcov/ftrace and whatever other mechanism might fit
(oprofile and kprobes come to mind).

To summarize my point of view: if it's only about moving the gcov
directory from / to /tracing then that can easily be done. If it's
about extending ftrace's control and presentation file structure
as well as its API to support non-function call based tracers and
per-object file control and presentation then that's a very long
way to go and I would rather not delay the inclusion of the gcov
kernel infrastructure that much.

