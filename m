Return-Path: <linux-kernel-owner+w=401wt.eu-S1751538AbZJNEfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbZJNEfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZJNEfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:35:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45125 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZJNEf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:35:29 -0400
Date: Tue, 13 Oct 2009 21:36:07 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091014043607.GA32114@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013205015.1ED524F7@magilla.sf.frob.com> <20091013232736.GA24392@us.ibm.com> <20091013235320.E90022746@magilla.sf.frob.com> <4AD525B3.2070906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD525B3.2070906@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
| On 10/13/2009 04:53 PM, Roland McGrath wrote:
| >> My only concern is the support of 64-bit clone flags on 32-bit architectures.
| > 
| > Oy.  I didn't realize there was serious consideration of having more than
| > 32 flags.  IMHO it would be a bad choice, since they could only be used via
| > clone3.  Having high-bit flags work in clone on 64-bit machines but not on
| > 32-bit machines just seems like a wrongly confusing way for things to be.
| > If any high-bits flags are constrained even on 64-bit machines to uses in
| > clone3 calls for sanity purposes, then it seems questionable IMHO to have
| > them be more flags in the same u64 at all.
| > 
| > Since all new features will be via this struct, various new kinds of things
| > could potentially be done by other new struct fields independent of flags.
| > But that would of course require putting enough reserved fields in now and
| > requiring that they be zero-filled now in anticipation of such future uses,
| > which is not very pleasant either.
| > 
| > In short, I guess I really am saying that "clone_flags_high" (or
| > "more_flags" or something) does seem better to me than any of the
| > possibilities for having more than 32 CLONE_* in the current flags word.
| > 
| 
| Overall it seems sane to:
| 
| a) make it an actual 3-argument call;
| b) make the existing flags a u32 forever, and make it a separate
|    argument;
| c) any new expansion can be via the struct, which may want to have
|    an "c3_flags" field first in the structure.

Wouldn't that make it a somewhat awkward interface - applications or
libc have to split the clone flags and specify them in two different
fields ? Do we need to preserve the u32 flags forever ? 

The closest example I can think of is the distinction between signal()
and sigaction(). sigaction() interface makes a lot of sense in part bc
it does not try to look like signal(). And strace seems to be able
decode flags like SA_RESTART and SA_SIGINFO with the pointer to the
sigaction buffer. 

Won't the debug tools be able to do the same with a pointer to
struct clone_args ?

If it needs the new features of clone3(), the application has to be
modified. At that point wouldn't it be easy to write a clone3() wrapper
that calls sys_clone3() if it exists or call sys_clone() if not ?

If clone3() supersedes clone(), all architectures could use the clone3()
interface and it would seem best to make clone3() as simple as possible
without having to preserve the u32 flags.

Would it help to use a type clone_flags_64_t to make the distinction
between types more explicit ?

Sukadev
