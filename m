Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYJ2Fqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYJ2Fqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYJ2FqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:46:10 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:57064 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbYJ2FqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:46:08 -0400
X-Authority-Analysis: v=1.0 c=1 a=DVPCwrHPdIgA:10 a=QE8jIfPi8SoA:10
 a=D19gQVrFAAAA:8 a=CCpqsmhAAAAA:8 a=FO2peys1YuKsKOnujr4A:9
 a=NghA5UAOXZ2vRdNKBYkA:7 a=5FIXRiFkVMO6OtMo9zSr00ffxHsA:4 a=jEp0ucaQiEUA:10
 a=50e4U0PicR4A:10
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock
	tracer
From: Tom Zanussi <zanussi@comcast.net>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
In-Reply-To: <c62985530810240826l2e025e94i51fdfd0fc70b0449@mail.gmail.com>
References: <48F10B0B.406@gmail.com>
	 <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
	 <y0mmygv18le.fsf@ton.toronto.redhat.com>
	 <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com>
	 <20081024143744.GA20768@redhat.com>
	 <alpine.DEB.1.10.0810241046300.3882@gandalf.stny.rr.com>
	 <20081024150239.GB20768@redhat.com>
	 <c62985530810240826l2e025e94i51fdfd0fc70b0449@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Oct 2008 00:46:02 -0500
Message-Id: <1225259162.7399.10.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a great idea.  Some thoughts on how it could work below...

On Fri, 2008-10-24 at 17:26 +0200, Frédéric Weisbecker wrote: 
> 2008/10/24 Frank Ch. Eigler <fche@redhat.com>:
> > That's what we do with the systemtap script, where kernel "handling"
> > consists of "running the machine code".
> >
> >> But have the user application interface be very simple, and perhaps
> >> even use perl or python.
> >
> > perl and python are pretty big procedural languages, and are not
> > easily compiled down to compact & quickly executed machine code. (I
> > take it no one is suggesting including a perl or python VM in the
> > kernel.) Plus, debugger-flavoured event-handling programming style
> > would not look nearly as compact in perl/python as in systemtap,
> which
> > is small and domain-specific.
> >
> > - FChE
> >
> 
> Actually what I thought is a style like this (Python like):
> 
> probe = Systemtap.probeFunc("lock_kernel")
> probe.captureUtime("utime"))
> probe.captureBacktrace("trace")
> probe.trace()
> 
> For an obvious set of batch work like that, that could be possible,
> perhaps even easy
> to implement an Api...
> When the object calls trace(), the userspace Systemtap analyse the
> list
> of work to do and then translate into commands in kernel space.
> 

When you say 'translate into commands in kernel space', I'm assuming in
the simplest case that you're thinking of the trace() method on your
Python probe object as generating systemtap probe code which in this
case would insert a probe on "lock_kernel" and collect the specific data
you named in the captureXXX methods.  If so, then the generated
systemtap code might look something like this (my systemtap coding is a
bit rusty and I don't know Python at all, so, please excuse any coding
problems - think of it as pseudo-code):

global ID_LOCK_KERNEL = 1;

/* systemtap code - in turn generates kernel code/module */
probe kernel.function("lock_kernel")
{
        /* log captureXXX fields using systemtap binary printf */
        printf("%b2%b4%s", ID_LOCK_KERNEL, utime, backtrace());
}

Once the trace method generates the systemtap probe code, it would then
construct the appropriate stap command line, exec it (which compiles the
generated probe code, inserts the module, arms the probes, etc) and from
then on sits around waiting for output from the probe...

> And the script could wait for events and then do its own processing
> with the captured events
> (do some operations on delays, on output....).
> 
> for event in probe.getEvent(): #blocking
> print event["utime"]
> trace = event["trace"] #Systemtap.trace object with specific
> fields and a default string repr
> print trace
> 
> It would be interpreted by Python itself, and you just have to capture
> commands and works
> sent through Api. Then, when the kernel has something to give, you
> just have to place it in the
> appripriate object and transmit it to the script which is waiting.
> Processing and output with the data are done by the python script.
> So actually, the python script only needs to ask you what data to
> capture. It's its own responsability to
> do wathever it wants with.

...as it receives the probe output, it would then extract the individual
events from the stream and dispatch them to the event-handling Python
code, which would be able to do whatever it wants to with...

There are at least two different ways I can think of to do this part.

The most straightforward would be to do it all in pure Python in the
script receiving the probe output.  Since I don't know Python, I'll use
pseudo-Perl, but the idea would be the same for Python:

open EVENT_STREAM, "stap -g lock-kernel-probe.stp"

while (<EVENT_STREAM>) {
  /* userspace Perl code: get and dispatch the next event id */
  $id = unpack("C"); /* Perl function for pulling apart C structs */

  /* dispatch to matching on_xxx 'handler' function */
  switch ($id) {
          case ID_LOCK_KERNEL:
                  /* unpack event, call handler using param array */
                  on_lock_kernel(unpack("XCLZ"));
                  break;
          default:
                  break;
  }
}

The Perl script code above continually grabs the next event on the
output stream, uses the first byte to figure out which event it
corresponds to and once it knows that, grabs the rest of the event data
and finally dispatches it to the 'handler' function for that event:

/* userspace Perl code: lock_kernel event 'handler' */
sub on_lock_kernel
{
        /* get the params */
        my ($id, $utime, $stacktrace) = @_;
        /* add to hash tracking times we've seen this stacktrace */
        $stacktraces{$stacktrace}++;
}

The handler code gets the data as usual via the params and does what it
wants with it; in this case it just uses the stack trace as a hash key
to keep a running count of the number of times that particular path was
hit.

Finally, at the end of the trace, a special end-of-trace handler gets
called, which can be used e.g. to dump the results out: 

/* userspace Perl code: at the end of the trace, dump what we've got */
sub on_end_trace_session
{
        while (($stacktrace, $count) each %stacktraces) {
                print "Stacktrace: $stacktrace\n";
                print "happened $stacktraces{$stacktrace} times\n";
        }
}

Another, presumably more efficient way to do the same thing, would be to
'embed' and instantiate an instance of the interpreter in the daemon
code.  The same (in this case) end-use Perl on_XXX event handlers would
be called, but the unpacking code and dispatch loop would be done in C
code as part of the daemon.  There, the fields of each event would be
translated into a form understandable by the interpreter and the handler
in the embedded interpreter invoked for each event:

/* userspace C code: get and dispatch the next event id */
unsigned char id = next_event_id(event_stream);

/* dispatch to matching on_xxx 'handler' function in Perl interpreter*/
switch (id) {
        case ID_LOCK_KERNEL:
                /* unpack event, call handler using param array */
                unsigned long = next_event_long(event_stream);
                char *string = next_event_string(event_stream);
                perl_invoke_on_lock_kernel(utime, stacktrace);
                break;
        default:
                break;
}

/* userspace C code: embedded Perl magic for invoking a Perl function */
void perl_invoke_on_lock_kernel(unsigned long utime, char *stacktrace)
{
        CALLBACK_SETUP(on_lock_kernel);
        XPUSHs(sv_2mortal(newSViv(utime)));
        XPUSHs(sv_2mortal(newSVpvn(stacktrace, strlen(stacktrace))));
        CALLBACK_CALL_AND_CLEANUP(on_lock_kernel);
}

The above dispatch loop, unpacking, etc is pretty much the same as in
the 'pure Perl' version, but done in C, and with the exception that it
does some interpreter-specific magic to invoke the interpreter methods,
which are exactly the same as in the 'pure' version.

I actually did this for every single event in the old LTT (not the
language binding, just the dispatching-to-to script-level handlers
part), so I know it works in practice and in fact it worked very well -
it was able to handle a pretty heavy trace stream while doing all the
nice Perl hashing/summing/etc in the event handlers it needed to do in
order to produce interesting and non-trivial results; IIRC it
comfortably handled full tracing (all events) during a kernel compile:

http://lkml.org/lkml/2004/9/1/197

And, not to knock the systemtap language, which is a fine and capable
language, but even the simple scripts I wrote for that demo did things
that exceeded the capabilities of the systemtap language (and the dtrace
language as well, I should add).

> What do you think?

I think what you want to do is quite doable, however you decide to do
it.  I know Python too has an API for embedding interpreters and
invoking script methods, as most non-trivial scripting languages do.  My
guess is that if you took the embedded interpreter approach for Python,
with a little generalization you could have a common layer to the
implementation that other languages could easily plug into.

Also, once you had the basic stuff working, you could extend it and in
the process make more use of the filtering and other capabilities
systemtap offers i.e. you needn't be limited to just using systemtap to
'scrape' data and do all the processing in the userspace Python script.

One example would again be stacktraces, which because of their size, are
things that you probably wouldn't want to send to userspace at a very
high frequency.  Here's an example of a combination systemtap kernel
script/Perl userspace script that continuously streams and converts
systemtap hashes into Perl hashes (because sytemtap kernel resources are
necessarily limited whereas userspace Perl interpreter resources
aren't):

http://sourceware.org/ml/systemtap/2005-q3/msg00550.html

It's a good example of a case where doing filtering in the kernel makes
a lot of sense.  With the hybrid systemtap/Perl/Python approach, you
make use of the strengths of systemtap while at the same time retaining
the full power of your language of choice. 

Of course, one of the challenges in using the more advanced features of
systemtap would be in making those capabilities available as natural
extensions to the supported scripting language(s).  But even without
them, I think the basic mode would be an extremely useful and powerful
complement to systemtap. 

Tom



