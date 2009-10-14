Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbZJNWgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbZJNWgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761290AbZJNWgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:36:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39490 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761253AbZJNWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:36:04 -0400
Date: Wed, 14 Oct 2009 15:36:34 -0700
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
Message-ID: <20091014223634.GB3515@us.ibm.com>
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

Ok, So will this work ?

	struct clone_args {
		u32 flags_high;		/* new clone flags (higher bits) */ 
		u32 reserved1;
		u32 nr_pids;
		u32 reserved2;
		u64 child_stack_base;
		u64 child_stack_size;
		u64 parent_tid_ptr;
		u64 child_tid_ptr;
		u64 reserved3;
	};

	sys_clone3(u32 flags_low, struct clone_args *args, pid_t *pid_list)

Even on 64bit architectures the applications have to use sys_clone3() for
the extended features.
