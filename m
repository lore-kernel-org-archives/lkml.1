Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZFJMzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZFJMzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZFJMzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:55:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZFJMzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:55:07 -0400
Date: Wed, 10 Jun 2009 08:55:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 08/11] tracing: add func and symfunc to tag format
In-Reply-To: <20090610074855.GB6016@nowhere>
Message-ID: <alpine.DEB.2.00.0906100852330.30552@gandalf.stny.rr.com>
References: <20090610054206.510574695@goodmis.org> <20090610054254.405148701@goodmis.org> <20090610074855.GB6016@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Frederic Weisbecker wrote:

> On Wed, Jun 10, 2009 at 01:42:14AM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This adds a way to print out a function name from a pointer the same way
> > that the Linux printf "%pF" does. Well the symfunc tag does.
> > 
> > If we change kmalloc and kfree formats to:
> > 
> >   TP_FORMAT("call_site=<symfunc:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
> > 
> > and
> > 
> >   TP_FORMAT("call_site=<func:call_site> ptr=<ptr:ptr>")
> > 
> > respectively, we would get something like:
> > 
> >    kmalloc: call_site=__alloc_skb+0x70/0x160 ptr=ffff88003d830800 bytes_req=680
> >    kfree: call_site=skb_release_data ptr=ffff88003d830800
> 
> 
> Nice!
> 
> I thought about func and func_offset, but symfunc seems enough.

func_offset is more intuitive, I'll switch it to that. Or maybe 
"funcoffset" or just "funcoff". OK, maybe not ;-)



> 
> 
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/trace_output.c      |    2 +-
> >  kernel/trace/trace_output.h      |    4 ++++
> >  kernel/trace/trace_read_binary.c |   27 +++++++++++++++++++++++++--
> >  3 files changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index 7938f3a..39d5eeb 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -326,7 +326,7 @@ static inline const char *kretprobed(const char *name)
> >  }
> >  #endif /* CONFIG_KRETPROBES */
> >  
> > -static int
> > +int
> >  seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
> >  {
> >  #ifdef CONFIG_KALLSYMS
> > diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
> > index d38bec4..412eee8 100644
> > --- a/kernel/trace/trace_output.h
> > +++ b/kernel/trace/trace_output.h
> > @@ -47,5 +47,9 @@ do {							\
> >  		return TRACE_TYPE_PARTIAL_LINE;		\
> >  } while (0)
> >  
> > +/* until we have a way with sprintf to do this */
> > +int seq_print_sym_short(struct trace_seq *s, const char *fmt,
> > +			unsigned long address);
> > +
> >  #endif
> >  
> > diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
> > index f3fdac8..9ff4ed8 100644
> > --- a/kernel/trace/trace_read_binary.c
> > +++ b/kernel/trace/trace_read_binary.c
> > @@ -10,7 +10,7 @@
> >  #include <linux/module.h>
> >  #include <linux/ctype.h>
> >  
> > -#include "trace.h"
> > +#include "trace_output.h"
> >  
> >  static DEFINE_MUTEX(buffer_lock);
> >  static struct trace_seq buffer;
> > @@ -23,7 +23,8 @@ static struct trace_seq buffer;
> >   * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
> >   *            <if:FIELD:TRUE:FALSE> | <ifmask:FIELD:MASK:TRUE:FALSE> |
> >   *            <nsec2sec:PRECISION:FIELD> | <nsec2usec:PRECISION:FIELD> |
> > - *            <nsec2msec:PRECISION:FIELD> | <major:FIELD> | <minor:FIELD>
> > + *            <nsec2msec:PRECISION:FIELD> | <major:FIELD> | <minor:FIELD> |
> > + *            <func:FIELD> | <symfunc:FIELD>
> >   * TYPE := int | uint | hex | ptr | string | strarray
> >   * FIELD := defined by the event structure
> >   * MASKS := MASK=NAME,MASKS | MASK=NAME
> > @@ -43,6 +44,8 @@ static struct trace_seq buffer;
> >   *  uint      : Same as int, but for unsigned.
> >   *  hex       : Print the field as a hex (ie. 0x4ab)
> >   *  ptr       : Print the field as a hex but without the '0x'.
> > + *  symfunc   : Print a ptr like the "%pF" does.
> > + *  func      : Like symfunc but without the address.
> >   *  string    : Used with dynamic sized strings (__string)
> >   *  strarray  : Used with static sized arrays (__array ( char , item, len)).
> >   *  if        : If the field is non zero, print the TRUE text,
> > @@ -80,6 +83,8 @@ enum field_types {
> >  	FIELD_IS_HEX,
> >  	FIELD_IS_MINOR,
> >  	FIELD_IS_MAJOR,
> > +	FIELD_IS_FUNC,
> > +	FIELD_IS_SYMFUNC,
> >  	FIELD_IS_NSEC2SEC,
> >  	FIELD_IS_NSEC2USEC,
> >  	FIELD_IS_NSEC2MSEC,
> > @@ -412,6 +417,8 @@ handle_field(struct ftrace_event_call *event,
> >  	case FIELD_IS_HEX:
> >  	case FIELD_IS_MINOR:
> >  	case FIELD_IS_MAJOR:
> > +	case FIELD_IS_FUNC:
> > +	case FIELD_IS_SYMFUNC:
> >  	case FIELD_IS_STRING:
> >  	case FIELD_IS_STRARRAY:
> >  		field = find_field(event, fmt, end - fmt);
> > @@ -594,6 +601,12 @@ ftrace_initialize_print(struct ftrace_event_call *event, const char *fmt, ...)
> >  		else if (strncmp(fmt, "ifmask:", 7) == 0)
> >  			field_type = FIELD_IS_IFMASK;
> >  
> > +		else if (strncmp(fmt, "func:", 5) == 0)
> > +			field_type = FIELD_IS_FUNC;
> > +
> > +		else if (strncmp(fmt, "symfunc:", 8) == 0)
> > +			field_type = FIELD_IS_SYMFUNC;
> > +
> >  		else if (strncmp(fmt, "nsec2sec:", 9) == 0)
> >  			field_type = FIELD_IS_NSEC2SEC;
> >  
> > @@ -785,6 +798,8 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
> >  		case FIELD_IS_UINT:
> >  		case FIELD_IS_HEX:
> >  		case FIELD_IS_PTR:
> > +		case FIELD_IS_FUNC:
> > +		case FIELD_IS_SYMFUNC:
> >  		case FIELD_IS_MAJOR:
> >  		case FIELD_IS_MINOR:
> >  			field = info->data.field;
> > @@ -837,6 +852,14 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
> >  				trace_seq_printf(s, "%u", MINOR(val));
> >  				break;
> >  
> > +			case FIELD_IS_SYMFUNC:
> > +				trace_seq_printf(s, "%pF", (void *)val);
> > +				break;
> > +
> > +			case FIELD_IS_FUNC:
> > +				seq_print_sym_short(s, "%s", val);
> 
> 
> May be after the merge window it would be nice to start use %pf (for
> now it's on another branch).
> I'll have more time to do such things in about two weeks.

Yeah, I spent about twenty minutes trying to find the "%pf" until I 
realized it was not in yet :-(

-- Steve

> 
> 
> 
> > +				break;
> > +
> >  			default:
> >  				/* hex should only print the size specified */
> >  				if (mask)
> > -- 
> > 1.6.3.1
> > 
> > -- 
> 
> 
