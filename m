Return-Path: <linux-kernel-owner+w=401wt.eu-S970063AbXEHXdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970063AbXEHXdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969893AbXEHXcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:32:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23260 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969888AbXEHXcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:32:15 -0400
Date: Tue, 8 May 2007 16:34:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Sokolovsky" <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, jeremy@goop.org
Subject: [PATCH] doc: volatile considered evil
Message-Id: <20070508163452.8b71f682.randy.dunlap@oracle.com>
In-Reply-To: <a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 13:07:51 -0700 Satyam Sharma wrote:

> Yes, definitely. Say Documentation/volatile-usage.txt -- this raw
> version could be touched a little bit, to have sections that clearly
> explain (1) how volatile makes the compiler generate trashy code, (2)
> why volatile doesn't even do what people _think_ it does, considering
> code is executed out-of-order by _hardware_ these days and not due to
> compilers like was the case 20 years back, (3) and so volatile ends up
> _hiding_ bugs from people and thus should be consigned to the trash
> can of history, (4) _except_ for _really special_ usage cases like
> reading IO mapped as memory.

Hi Satyam,

If you would like to organize it like that, I'd be happy to
turn it over to you.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From: Randy Dunlap <randy.dunlap@oracle.com>

Add information on the problems with the C-language "volatile" keyword
and why it should not be used (most of the time).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/volatile-usage.txt |  129 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

--- /dev/null
+++ linux-2.6.21-git10/Documentation/volatile-usage.txt
@@ -0,0 +1,129 @@
+***** "volatile" considered useless and evil:  Just Say NO! *****
+
+Do not use the C-language "volatile" keyword
+(extracted from lkml emails from Linus)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+[Comment about a patch:]
+
+> Also made all the relevant mce_log fields volatile for further safety.
+
+I refuse to apply this part.
+
+If the memory barriers are right, then the "volatile" doesn't matter.
+
+And if the memory barriers aren't right, then "volatile" doesn't help.
+
+Using "volatile" in data structures is basically _always_ a bug.
+
+The only acceptable uses for "volatile" are:
+
+ - in _code_, i.e., for things like the definition of "readb()" etc, where we
+   use it to force a particular access.
+ - with inline asms
+ - on "jiffies", for stupid legacy reasons
+
+Basically, a volatile on a data structure can NEVER be right. If it makes
+a difference, it's a sign of improper locking.
+
+And the reason I refuse to apply that part of the patch is that anybody
+who even _thinks_ that they make a difference is horribly and utterly
+confused, and doesn't understand locking.
+
+So please _never_ use them like this.
+
+
+> mce_log is fully lockless - it deals with machine checks which act like NMIs.
+> That is it's problem.
+>
+> In theory the memory barriers should be sufficient, the volatiles are
+> just an additional safety net to make it clear to humans/compiler these memory
+> areas can change any time.
+
+If the memory barriers aren't sufficient, the volatiles are useless. If
+the memory barriers _are_ sufficient, the volatiles are useless.
+
+See? They're useless.
+
+The only thing they do is
+
+ - potentially make the compiler generate worse code for no reason (the
+   "no reason" being that if there aren't any barriers in between, the
+   compiler _should_ merge accesses)
+
+ - make some people _believe_ that that compiler does something "right".
+
+The first point doesn't much matter. The second point matters a LOT.
+
+Anybody who thinks "volatile" matters is WRONG. As such, a "volatile" is
+anti-documentation - it makes people think that something is true that is
+NOT true.
+
+In other words, volatile on data structures is _evil_, because it instills
+the wrong kind of beliefs in people. "volatility" is not a data structure
+issue. It's a matter of the _code_ working on the data structure.
+
+
+"volatile" really _is_ misdesigned. The semantics of it are so unclear as
+to be totally useless. The only thing "volatile" can ever do is generate
+worse code, WITH NO UPSIDES.
+
+Historically (and from the standpoint of the C standard), the definition
+of "volatile" is that any access is "visible" in the machine, and it
+really kind of makes sense for hardware accesses, except these days
+hardware accesses have other rules that are _not_ covered by "volatile",
+so you can't actually use them for that.
+
+And for accesses that have some software rules (i.e., not IO devices etc),
+the rules for "volatile" are too vague to be useful.
+
+So if you actually have rules about how to access a particular piece of
+memory, just make those rules _explicit_. Use the real rules. Not
+volatile, because volatile will always do the wrong thing.
+
+Also, more importantly, "volatile" is on the wrong _part_ of the whole
+system. In C, it's "data" that is volatile, but that is insane. Data
+isn't volatile - _accesses_ are volatile. So it may make sense to say
+"make this particular _access_ be careful", but not "make all accesses to
+this data use some random strategy".
+
+So the only thing "volatile" is potentially useful for is:
+
+ - actual accessor functions can use it in a _cast_ to make one particular
+   access follow the rules of "don't cache this one dereference". That is
+   useful as part of a _bigger_ set of rules about that access (i.e., it
+   might be the internal implementation of a "readb()", for example).
+
+ - for "random number generation" data locations, where you literally
+   don't _have_ any rules except "it's a random number". The only really
+   valid example of this is the "jiffy" timer tick.
+
+Any other use of "volatile" is almost certainly a bug, or just useless.
+
+Side note: it's also totally possible that a volatiles _hides_ a bug, i.e.,
+removing the volatile ends up having bad effects, but that's because the
+software itself isn't actually following the rules (or, more commonly, the
+rules are broken, and somebody added "volatile" to hide the problem).
+
+It's a bug if the volatile means that you don't follow the proper protocol
+for accessing the data, and it's useless (and generally generates worse
+code) if you already do.
+
+So just say NO! to volatile except under the above circumstances.
+
+
+
+[from another email thread:]
+
+I suspect we should just face up to the fact that:
+
+ (a) "volatile" on kernel data is basically always a bug, and you should
+     use locking. "volatile" doesn't help anything at all with memory
+     ordering and friends, so it's insane to think it "solves" anything on
+     its own.
+ (b) on "iomem" pointers it does make sense, but those need special
+     accessor functions _anyway_, so things like test_bit() wouldn't work
+     on them.
+ (c) if you spin on a value [that's] changing, you should use "cpu_relax()" or
+     "barrier()" anyway, which will force gcc to re-load any values from
+     memory over the loop.
