Return-Path: <linux-kernel-owner+w=401wt.eu-S932253Ab0ANSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0ANSqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814Ab0ANSqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:46:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0ANSqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:46:17 -0500
Message-ID: <4B4F665F.1090900@redhat.com>
Date: Thu, 14 Jan 2010 13:45:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <4B4D02B8.5020801@zytor.com> <20100113020610.GB29314@Krystal> <4B4D525A.5020101@zytor.com> <20100113143050.GB30875@Krystal>
In-Reply-To: <20100113143050.GB30875@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>> It is *not* necessary to wait for the breakpoint handlers to return, as
>> long as they will get to IRET eventually, since IRET is a jump and a
>> serializing instruction.
> 
> Ah, I see. So the added smp_mb() would not be needed then, as long as we
> know that the other CPUs either are currently running the IPI handler or
> have executed it. IOW: they will execute IRET very soon or they just
> executed it since the int3 have been written. I am a bit concerned about
> NMIs coming in this race window, but as they need to have started after
> we have put the breakpoint, that should be OK. (note: entry_*.S
> modifications are needed to support nesting breakpoint handlers in NMIs)

Hmm, if we support this to modify NMI code, it seems that we need to
support not only nesting breakpoint handling but also nesting NMIs,
because nesting NMI is unblocked when next IRET (of breakpoint) is
issued.

>From Intel's Software Developer’s Manual Vol.3A 5.7.1 Handling Multiple NMIs
said below.
---
While an NMI interrupt handler is executing, the processor disables additional calls to
the NMI handler until the next IRET instruction is executed. This blocking of subse-
quent NMIs prevents stacking up calls to the NMI handler. [...]
---

I assume that your below patch tried to solve this issue, right?
http://lkml.indiana.edu/hypermail/linux/kernel/0804.1/0965.html

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

