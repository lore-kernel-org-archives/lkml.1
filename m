Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZJVQHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZJVQHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZJVQHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:07:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57392 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZJVQHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:07:00 -0400
Date: Thu, 22 Oct 2009 08:54:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Takashi Iwai <takashi.iwai@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with string (charp) module parameters
Message-ID: <20091022155435.GA6277@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <s5haazv1sw5.wl%tiwai@suse.de> <200910212341.06025.rusty@rustcorp.com.au> <6dc076840910211913l1cf12e82tbb9151da78e41422@mail.gmail.com> <200910230050.41790.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910230050.41790.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 12:50:41AM +1030, Rusty Russell wrote:
> On Thu, 22 Oct 2009 12:43:36 pm Takashi Iwai wrote:
> > Hi Rusty,
> > 
> > (sending from gmail address since VPN doesn't work here in hotel...)
> > 
> > On Wed, Oct 21, 2009 at 3:11 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > On Tue, 13 Oct 2009 09:07:46 pm Takashi Iwai wrote:
> > >> * The handling of parameter array is pretty buggy now.
> > >>   kp->perm and kp->flags aren't properly initialized in
> > >>   param_array().  Thus, you might call kfree() with invalid pointers,
> > >>   or pass a wrong type for bool.
> > >
> > > Yes, an array of charp isn't going to work.  Erk, I switched one bug for
> > > another :(
> > >
> > >> So, the situation looks messy right now, not only about the section
> > >> issue.  If we allow kmalloc of each parameter array element, the flag
> > >> must be associated to each element, not a global one to the array.
> > >>
> > >> Thoughts?
> > >
> > > Yes, that's hard.  There's only one place which currently has a writable
> > > array parameter: drivers/usb/atm/ueagle-atm.c, and it's root only.
> > >
> > > OK, for 2.6.32, we remove the const.  In the longer term, I'm reworking how
> > > this is done entirely.
> > 
> > As far as I checked, removing only const doesn't suffice on x86.
> > The problem is rather the __param section assignment.
> > We'd need to get rid of that, too, if we keep the code in the current way.
> 
> Something like this?
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -147,6 +147,10 @@
>  	MEM_KEEP(init.data)						\
>  	MEM_KEEP(exit.data)						\
>  	. = ALIGN(8);							\
> +	VMLINUX_SYMBOL(__start___param) = .;				\
> +	*(__param)							\
> +	VMLINUX_SYMBOL(__stop___param) = .;				\
> +	. = ALIGN(8);							\
>  	VMLINUX_SYMBOL(__start___markers) = .;				\
>  	*(__markers)							\
>  	VMLINUX_SYMBOL(__stop___markers) = .;				\
> @@ -336,15 +340,7 @@
>  		MEM_KEEP(init.rodata)					\
>  		MEM_KEEP(exit.rodata)					\
>  	}								\
> -									\
> -	/* Built-in module parameters. */				\
> -	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
> -		VMLINUX_SYMBOL(__start___param) = .;			\
> -		*(__param)						\
> -		VMLINUX_SYMBOL(__stop___param) = .;			\
> -		. = ALIGN((align));					\
> -		VMLINUX_SYMBOL(__end_rodata) = .;			\
> -	}								\
> +	VMLINUX_SYMBOL(__end_rodata) = .;				\
>  	. = ALIGN((align));
> 
>  /* RODATA & RO_DATA provided for backward compatibility.
> 
> 
> This would work for 2.6.32, for 2.6.33 I have a different solution.
> 
> > It's not only for avoiding the mess to separate static and kmalloc
> > strings but also for
> > avoiding races between the referrer and the sysfs-write of char
> > pointer.  (In general, we
> > have no lock for parameters.)
> 
> Good point.  We should use rcu here.  But there's still a race with copying
> in strings of any kind.

Assuming that I actually understand the problem...  ;-)

The usual way of handling this sort of race is to allocate (or have
pre-allocated) a block of memory to hold the new string, copy it,
then publish a pointer to it.  That way readers either see the entire
new string or they don't, no partially copied strings.

						Thanx, Paul

> > As you pointed out, there are no many users of writable charp parameters.
> > So, replacing is easy task.  In that way, we can keep struct
> > kernel_parameter as const
> > gracefully without hustling any big code change.
> 
> But we'd need to make sure noone adds one in future.  After all, you tried
> to add one and found this problem!
> 
> I'll post my current patch series: it needs testing, but I'd appreciate
> your thoughts.
> 
> Thanks!
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
