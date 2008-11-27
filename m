Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYK0NSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYK0NSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYK0NSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:18:43 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:64306 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYK0NSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nz/aTvruh33WyoHEs7k/DJTW2og9PuiygST5fD4S7m40b90rS3BsYRYMTbSKME0fzw
         Pk++04/SvCnEXd2SWl0pQ51jXgn6t9aAFl8Z0Xxw6CAKTrBTTsjDaGLu5kOiGpijwRXJ
         YoqFpHXkThDcCmi6n+wtFjnGSRlZ/GlClB8G4=
Message-ID: <c62985530811270518n161ed600k930eefce7291ccdd@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:18:41 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081127112953.GA23702@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
	 <1227783300.4454.1410.camel@twins> <20081127112953.GA23702@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Ingo Molnar <mingo@elte.hu>:
> That extra column should be a trace_option though - default-off. (it
> uses up quite some screen real estate) It would have to have a width
> of 14 characters to be practical:
>
>    ssssssss-12345
>
> mockup:
>
> ----------------------------------------------------------------
> CPU)     task-PID   |     cost    |  function
> ----------------------------------------------------------------
>
>  0)     bash-54320 |             |  sys_read() {
>  0)     bash-54320 |    0.331 us |    fget_light();
>  0)     bash-54320 |             |    vfs_read() {
>  0) mycomman-1234  |             |      rw_verify_area() {
>  0) mycomman-1234  |  121.444 us |        func();
>
> Note some details:
>
> 1) longer comm names can be stripped off at 7 chars - 7 chars is
>   enough to recognize most of the things and the PID is good enough
>   for extra separation)
>
> 2) the ssssssss-12345 task identifier is _center_ aligned. It's a rare
>   alignment case but useful here: most people look at the command
>   portion and the whole string must be greppable and useful in traces
>   as an identifier - so right-aligning the PID is not a good
>   solution.
>
> 3) there's vertical separation after the task portion as well. This
>   helps us ignore the task portion when we want to look at only the
>   code and the cost of it. (the common case)


Yeah! I agree with all of that.
And as you said, that should be an option deactivated by default.


>> comm/pid only in the separator is useless, you cannot grep stuff
>> like that, also, what's up with those '8's ?
>
> yeah, that context-switch separator is horrible.
>
> We can keep the separator, but as something saner, like:
>
> ---------------------------------------------------------
> CPU)     cost    |  function
> ---------------------------------------------------------
>
>  0)             |  sys_read() {
>  0)    0.331 us |    fget_light();
>  0)             |    vfs_read() {
>  0)             |      rw_verify_area() {
>  0)             |        security_file_permission() {
>  0)    0.306 us |          cap_file_permission();
>  0)    0.300 us |          cap_file_permission();
>  0)    8.909 us |        }
>  0)    0.993 us |      }
>  0)   11.649 us |    }
>  0)             |    do_sync_read() {
>                 .   -------------------------
>  0)             ==> [ bash-2794 => cat-1234 ]
>                     -------------------------
>
>  0)             |        __sock_recvmsg() {
>  0)             |          security_socket_recvmsg() {
>  0)  100.319 us |            cap_socket_recvmsg();
> ---------------------------------------------------------
>
> Note the six small details:
>
> 1) '==>' sign put to the vertical separator. This shows that something
>   flow-intrusive (context-switch) happened.
>
> 2) The context-switch printout is in a little box that separates it
>   from the flow of the outgoing task.
>
> 3) there's an extra newline for the incoming flow. Context-switches
>   are usually attached to the outgoing flow - the incoming flow is
>   picked semi-randomly, so the newline is a visual separator for that
>   fact.
>
> 4) it uses the ssssssss-12345 taskname convention for both the
>   outgoing and the incoming task. That makes it greppable
>   generally.
>
> 5) the '----------' lines of the 'box' have no CPU nor task or cost
>   field. That makes it easy to grep them out - but they are still
>   helpful visual cues. They are variable length but that's solvable
>   by using an 'open box' simplification:
>
>     0)    0.300 us |          cap_file_permission();
>     0)    8.909 us |        }
>     0)    0.993 us |      }
>     0)   11.649 us |    }
>     0)             |    do_sync_read() {
>                    .   -----------------------------------
>     0)             ==> [ bash-2794 => cat-1234
>                        -----------------------------------
>
>   Note how the box top and bottom is 35 characters, fixed. That looks
>   good with most task identifiers. Even in the worst-case length
>   length situation it looks good:
>
>                    .   -----------------------------------
>     0)             ==> [ mycomman-12345 => mycomman-12345
>                        -----------------------------------
>
>   Or it could be printed out variable length as well - it's a
>   solvable task :-)
>
> 6) note the small dot in the leadin to a context-switch: it's
>   intentional.
>
>        Ingo
>

That's fair.
I will apply these advices, probably divided in multiple patches....
