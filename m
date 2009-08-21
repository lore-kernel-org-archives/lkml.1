Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZHUPTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZHUPTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZHUPTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:19:52 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:13249 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZHUPTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:19:51 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/4 -v2] perf: rework the whole read vs group stuff
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470908210747u125dc6d6y76a9ca7f1af41160@mail.gmail.com>
References: <20090813094752.433445710@chello.nl>
	 <20090813103655.117411814@chello.nl>
	 <7c86c4470908210747u125dc6d6y76a9ca7f1af41160@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 17:19:36 +0200
Message-Id: <1250867976.7538.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 16:47 +0200, stephane eranian wrote:
> Hi,
> 
> Well, I tried that and it brings more complexity than needed
> especially with regards to
> extracting the ID for events when you're doing grouping.
> 
> To extract the ID, one has to read out a struct as follows:
>  *      { u64           nr;
>  *        { u64         time_enabled; } && PERF_FORMAT_ENABLED
>  *        { u64         time_running; } && PERF_FORMAT_RUNNING
>  *        { u64         value;
>  *          { u64       id;           } && PERF_FORMAT_ID
>  *        }             cntr[nr];
>  *      } && PERF_FORMAT_GROUP
> 
> Supposedly, you should have to do this only once per group. Reading
> this stuff using the group leader should yield the values of all the other
> events. This is not what I have observed. All events report the same
> ID as the leader. Not clear why.

Hmm, that's a bug alright.

> As I suggested in a previous message, I don't think all of this is necessary.
> If a tool was able to pass the ID to associate with an event, then there
> would be no need for a read(). Furthermore, it would make it easier to pick
> an ID which suites the tool's data structure. For instance, if you create
> 4 events in a group, the ID could be 0,1,2,3 and would most likely map to
> an index in the array used by the tool to manage the perf_counter structures.
> That would also make it easier in the critical path in the signal handler. No
> need to have a lookup table to map "random" ID to ID more relevant
> for the tool. The ID does not need to be very wide. IDs are relevant only if
> one uses group sampling. Therefore the ID needs to identify an event within
> a group. Could use a reserved field in perf_counter_attr or add an ioctl() to
> assign an ID.

ID are also needed when you want to allow mixing of the output buffers
(in any sense). That is, perf writes all mmap() data into a single file,
which mixes the streams, the other example is the output redirection
patch I posted the other day which basically does the same in-kernel.

A user-provided ID is still possible by extending perf_counter_attr. We
could add this later.

We still need a per-counter unique ID for the inherited thing, and I was
worrying that perhaps we would need to worry about collisions, but I
think these id spaces can be considered separate.

---
Subject: perf_counter: Fix typo in read() output generation

When you iterate a list, using the iterator is useful.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 36f65e2..f274e19 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1791,7 +1791,7 @@ static int perf_counter_read_group(struct perf_counter *counter,
 	size += err;
 
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-		err = perf_counter_read_entry(counter, read_format,
+		err = perf_counter_read_entry(sub, read_format,
 				buf + size);
 		if (err < 0)
 			return err;


