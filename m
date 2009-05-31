Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZEaNnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZEaNnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 09:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZEaNnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 09:43:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35691 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZEaNnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 09:43:13 -0400
Message-ID: <4A228988.4060909@redhat.com>
Date: Sun, 31 May 2009 09:43:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v8 0/7] tracing: kprobe-based event tracer and x86
 instruction decoder
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090530080503.GA15755@infradead.org>
In-Reply-To: <20090530080503.GA15755@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Small question to start with: What's your (or Hitachi s/Red Hat's) use case
> for this?  It's obviously really cool technology, but I fear without
> some good user space side to make it easy to use it will most likely
> bit-rot which would be sad.

Good question,
Frankly to say, this was started just for the in-kernel user of kprobes.
However, now I think this can be used for some ideas,
- Quick debugging (checking variables, execution path, etc.) in asm level.
  (elfutils might help us to make it source level debugging)
- Prototyping new tracepoints.
- Stress test of kprobes to find functions which should be __kprobes.
- Vehicle of tracing facilities which will be ported from systemtap runtime.
- As Frank said, we can make systemtap to control this for simple scripts.

Even now, it's not hard to use systemtap for finding variables in
stack/registers. Key options are -v and -p2,

e.g.
$ stap -v -p2 -e 'probe kernel.statement("*@fs/open.c:1024")\
 {printf("%d", $files)}'

Then, you'll get below output,
------
# functions
_dwarf_tvar_get_files_0:long ()
%{{
  {
    uint64_t addr;
    { // DWARF expression: 0x5c
    { uint64_t value = fetch_register (12);addr = value; }
    }
    THIS->__retvalue = addr;
  }
  goto out;
if (0) goto deref_fault;
deref_fault:
  goto out;
}
/* pure */%}
# probes
kernel.statement("fd_install@/home/mhiramat/ksrc/linux-2.6-tip/fs/open.c:1024")
 /* pc=_stext+0xd1f72 */ /* <- kernel.statement("*@fs/open.c:1024") */
printf("%d", _dwarf_tvar_get_files_0())
------

This shows that 'fs/open.c:1024' is located at _stext+0xd1f72, and
'files' is mapped to %r12 (note, pt_regs mapping is different from
dwarf register mapping.) So, below command adds probe at
fs/open.c:1024 and trace 'files' variable :-)

$ echo p _stext+0xd1f72 %r12 > /debug/tracing/kprobe_events


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

