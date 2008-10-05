Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYJEVu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYJEVu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYJEVuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:50:17 -0400
Received: from www.tglx.de ([62.245.132.106]:48302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbYJEVuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:50:16 -0400
Date: Sun, 5 Oct 2008 23:49:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
 hotplug CPUs to be set at compile time
In-Reply-To: <48E9261A.9060501@firstfloor.org>
Message-ID: <alpine.LFD.2.00.0810052252520.3398@apollo>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org>
 <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo> <20081005152025.GA27066@elte.hu> <alpine.LFD.2.00.0810051732380.3398@apollo>
 <48E9261A.9060501@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Andi Kleen wrote:
> > 
> > Please lets get rid of all this.
> 
> The result is that there's no way to override a BIOS now that
> doesn't declare the number of hotplug CPUs with the Linux hotplug
> extension.
> 
> Completely trusting the BIOS seems like a bad idea.
> 
> So I think you still need the command line parameter back, otherwise there's no
> way to override the BIOS.
> 
> -Andi (who wished you guys would check with the original author
> before removing code you clearly don't understand)

Sigh, could you please start thinking first before you insult me ?

Chucks problem is that the BIOS advertises

1 present CPU and 1 disabled CPU

Now the current code does not switch to UP alternatives because the
check in alternatives.c is:

      if (num_possible_cpus() == 1 ...

      which evaluates to false, due to:

      num_possible_cpus = num_processors + additional_cpus

      where additional_cpus = disabled_cpus when no command line
      parameter is given, i.e. the default behaviour of the kernel.

      and where num_processors = num_present_cpus()

      so in Chucks case num_possible_cpus() == 2

Your proposed solution is:

     exporting additional_cpus  and change the check to:

     if ((num_possible_cpus() - additional_cpus) == 1 ...

This is simply stupid. We have the information already in
num_present_cpus() and that's the correct check in the alternatives
code.

     if (num_present_cpus() == 1 ...

This is not a question of trusting the BIOS: 

If we can not trust present_cpu_map then additional_cpus does not help
at all.

additional_cpus is useless ballast.

Thanks,

	tglx - who refrains from adding a nasty insulting comment
