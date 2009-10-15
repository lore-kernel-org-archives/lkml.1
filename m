Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbZJOAQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbZJOAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762216AbZJOAQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:16:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38169 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762019AbZJOAQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:16:56 -0400
Date: Wed, 14 Oct 2009 17:17:39 -0700
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
Message-ID: <20091015001739.GC3515@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013205015.1ED524F7@magilla.sf.frob.com> <20091013232736.GA24392@us.ibm.com> <20091013235320.E90022746@magilla.sf.frob.com> <4AD525B3.2070906@zytor.com> <20091014223634.GB3515@us.ibm.com> <4AD6557D.3090501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD6557D.3090501@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
| On 10/14/2009 03:36 PM, Sukadev Bhattiprolu wrote:
| > H. Peter Anvin [hpa@zytor.com] wrote:
| > | 
| > | Overall it seems sane to:
| > | 
| > | a) make it an actual 3-argument call;
| > | b) make the existing flags a u32 forever, and make it a separate
| > |    argument;
| > | c) any new expansion can be via the struct, which may want to have
| > |    an "c3_flags" field first in the structure.
| > 
| > Ok, So will this work ?
| > 
| > 	struct clone_args {
| > 		u32 flags_high;		/* new clone flags (higher bits) */ 
| > 		u32 reserved1;
| > 		u32 nr_pids;
| > 		u32 reserved2;
| > 		u64 child_stack_base;
| > 		u64 child_stack_size;
| > 		u64 parent_tid_ptr;
| > 		u64 child_tid_ptr;
| > 		u64 reserved3;
| > 	};
| > 
| > 	sys_clone3(u32 flags_low, struct clone_args *args, pid_t *pid_list)
| > 
| > Even on 64bit architectures the applications have to use sys_clone3() for
| > the extended features.
| 
| Yes, although I'd just make flags_high a u64.

so we allow 96 bits for flags ?

| The other thing that might be worthwhile is to have a length field on
| the structure; that way we could add new fields at the end if ever
| necessary in the future.

So:
	struct clone_args {
		u64 flags_high;		/* new clone flags (higher bits) */ 
		u64 reserved1;

		u32 nr_pids;
		u32 clone_args_size;

		u64 child_stack_base;
		u64 child_stack_size;

		u64 parent_tid_ptr;
		u64 child_tid_ptr;
	};

	sys_clone3(u32 flags_low, struct clone_args *args, pid_t *pid_list)

BTW, on 64-bit architectures, the flags_low would be 64-bits, but the high-
bits there would be ignored right ?

Not sure if we need a second reserved field now that we add ->clone_args_size.

Thanks,

Sukadev
