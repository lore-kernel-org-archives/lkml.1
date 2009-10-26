Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZJZRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZJZRLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZJZRLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:11:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZJZRLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:11:17 -0400
Subject: Re: [PATCH -v5 10/11] tracing: add function graph tracer support
 for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <1256576225.5642.244.camel@falcon>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
	 <ac9c325539cc056d9539c96a68743a425f9612ce.1256483735.git.wuzhangjin@gmail.com>
	 <1256570001.26028.298.camel@gandalf.stny.rr.com>
	 <1256573467.5642.214.camel@falcon>
	 <1256574775.26028.321.camel@gandalf.stny.rr.com>
	 <1256576225.5642.244.camel@falcon>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 13:11:19 -0400
Message-Id: <1256577079.26028.332.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 00:57 +0800, Wu Zhangjin wrote:

> > I would be even more paranoid, and make sure each of those stores, store
> > into sp.
> 
> get it :-)
> 
> (I need to be more paranoid too, otherwise, Steven will not accept my
> patches!)

Sure I would accept them. I don't know of any MIPS boxes that Linus
runs. So I'm not afraid of crashing his boxes with these patches ;-)

> > > 
> > > We need to really stop before ftrace_push_return_trace to avoid messing
> > > with the stack :-) but if we have stopped the tracer, is it important to
> > > mess with the stack or not?
> > 
> > The ftrace_push_return_trace does not test if the trace stopped, that is
> > expected to be done by the caller. If you mess with the stack set up,
> > you will crash the box. Remember, before the failure, you could have
> > already replaced return jumps. Those will still be falling back to the
> > return_to_handler. If you mess with the stack, but don't update the
> > return, the other returns will be out of sync and call the wrong return
> > address.
> > 
> 
> As you can see, after stopping the function graph tracer(here the function is non-leaf)
> with ftrace_graph_stop() in ftrace_get_parent_addr(), I return the old parent_addr,
> this is only the stack address in the stack space of ftrace_graph_caller, which means
> that, I never touch the real stack address of the non-leaf function, and it will not trap
> into the return_to_handler hooker 'Cause the non-leaf function will load it's own normal
> return address from it's own stack, and then just return back normally.

But then you should not be calling the push function. That will still
push onto the graph stack.

The function graph tracer keeps a separate return stack
(current->ret_stack). This is what holds the return addresses.


(normal operation)

func1
  jalr _mcount
 
           push ra onto ret_stack
           replace ra with return_to_handler

  jr ra  --> return_to_handler


return_to_handler

   pop ret_stack, have original ra
   jr original_ra


Now what happens if we fail a call but still push to ret_stack

func1
  jalr _mcount

         (success)
          push ra onto ret_stack
          replace ra with return_to_handler

  jalr func2

    func2
      jalr _mcount

          (failed)
          push ra onto ret_stack  <<-- this is wrong!
          keep original ra

      jr ra << does not call tracer function!!!

  jr ra  << goes to return_to_handler


return_to_handler

   pop ra from ret_stack <<--- has func2 ra not func1 ra!!

jr func1_ra

**** CRASH ****

Make sense?

-- Steve

   

