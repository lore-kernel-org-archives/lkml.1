Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbZCZWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbZCZWkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZCZWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:40:37 -0400
Received: from smtp3.ono.com ([62.42.230.176]:43511 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752414AbZCZWkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:40:37 -0400
Date: Thu, 26 Mar 2009 23:40:30 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: recommended programming practices for writing (was Linux
 2.6.29)
Message-ID: <20090326234030.4bce8801@werewolf.home>
In-Reply-To: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
References: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
X-Mailer: Claws Mail 3.7.1cvs24 (GTK+ 2.16.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 15:03:28 -0400, Adam Turk <bofh1234@hotmail.com> wrote:

> 
> I have been reading the Linux 2.6.29 thread with interest.  I have written several (10 or so) C programs that write large amounts of data (between 1 and 2 GB file sizes are common).  A snippet of code looks like this:
> 
> if((fptr = fopen(outfilename,"w")) == NULL) {
>   printf("File %s could not be created\n", outfilename);
> }
> else {
>   fprintf(fptr,"%s\n",datablock);
>   while(!writeouput(datablock,amount,tax)) {
>     getnext(dtablock)
>     fprintf(fptr,"%s\n",datablock);
>   }
>   fclose(fptr);
> }
> 
> I learned C about 15 years ago and there was no mention of a fsync.  My C book doesn't mention fsync either.  Granted I have written only 25-30 applications in the last 15 years or so so I am not an expert C programmer. 
> 
> From what Linus posted about git and checking the return from fclose I think I going to start doing that.  I also think I am going to start checking the return from fprintf and maybe write to a /tmp/file and then rename it.
> 
> So is there a C fsync that I should add before my fclose?
> What is the proper way to write to files?
> 
> Is what I am thinking about doing something that would be good or is it just a lack of my understanding the problem?
> 

You _really_ should not worry bout that. You write a file the way C or Fortran
or ADA tells you to do so. I think no language standard worries about when
the file really is dumped to disk from the kernel side. Even fflush() just
guarantees that the _high level_ buffer in the C library is sent to the kernel
routines to write to the device. But none gives you a standard function to
get the pages really witten to disk, or wait even till the hardware queues
have really sent the data to the platter. You will never know that.

Assume this world is imperfect. Your computer can always crash. I think just
routines like link/unlink/rename could be near to metal. And with journaled
filesystems, even that.

>From what I have understood reading LKML these years, if you do something like

    fwrite(one megabyte)
    fsync()
    pause()
    fwrite(other megabyte)

and unplug the cord while in the pause, nobody guarantees you that the first
megabyte is on the disk. Live with it.

PD: I'm not saying this is good, I think it's just the way it is.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
