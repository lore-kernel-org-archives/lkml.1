Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbZKXOr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbZKXOr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbZKXOr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:47:29 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50795 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbZKXOr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:47:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JZTrAhhRGZ2K8V7kVIpL1cfIRIFMysGCC/Au+2rs92krx7hwMdduKFSMm8XcVcnqTu
         iYUdJf+RDKd48FhUvaFmYiPM0AvCgCoAMCEydgQSBGLmHMpUh7c1dWUrDb4+F4LcfyHh
         3K1OPR2OVVz6y4n6no3gDUmNTeIQON3u/fLRM=
MIME-Version: 1.0
In-Reply-To: <FEBDE48FB0344846BAE4FB976A42642802BA8271@GLKMS2101.GREENLNK.NET>
References: <d0ced6d70911190416w3a354a50jcb0e93934805ca07@mail.gmail.com>
	 <FEBDE48FB0344846BAE4FB976A42642802BA8271@GLKMS2101.GREENLNK.NET>
Date: Tue, 24 Nov 2009 15:47:32 +0100
Message-ID: <4e5e476b0911240647i6d6b7166ucc5d6a30cce8841a@mail.gmail.com>
Subject: Re: Kernel 2.6.27.7-9 for Suse 11.1 help required with CPU Clock 
	freq/speed/ticks
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Ahmed, Subhan (UK)" <Subhan.Ahmed@baesystems.com>
Cc: Subhan Ahmed <subhan_ahmed@hotmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 1:32 PM, Ahmed, Subhan (UK)
<Subhan.Ahmed@baesystems.com> wrote:
> Hi All,
>
> I know this is not  email list for programming questions but it relates
> to Kernel as well, in fact relying on kernel. Could someone please
> through a light or guide me to the right direction.
>
>
> Problem Statement:      High CPU clock speed/freq
> Requirement:            Obtain a stable CPU clock ticks/speed/freq on
> Suse 11.1 with kernel 2.6.27.7-9
> Questions:                      Please refer to the bottom of this page
> Artifacts in Use:
> -----------------------------------
> OS:                                     Suse 11.1
> GCC Version:            4.3.2 (Suse Linux) [gcc_4_3-brach revision
> 141291]
> Kernel:                         2.6.27.7-9
> Kernel Mods:
>                                        * Un-check the Tickless option
>                                        * Timer Frequency - 1000Hz
>                                        * Preempt kernel
>
> Others 1
> -----------
> OS:                                     Suse 10.2
> GCC Version:            4.1.2 20061115 (prerelease)(SUSE Linux)
> Kernel:                         2.6.18.2-34-default
> Kernel Mods:
>                                        * Preemptible Kernel
> (Low-Latency Desktop) (NEW)
>                                        * Preempt The Big Kernel Lock
> (NEW)
>                                        * Timer frequency (NEW) - 1000
> Hz (NEW)
>
> Others 2
> -----------
> OS:                                     Suse 9.3
> GCC Version:            3.3.5 20050117 (prerelease)(SUSE Linux)
> Kernel                          2.6.11.4-20a-default
> Kernel Mods:            None
>
> I executed the following c++ code on the above stated builds
>
> CODE - file name test.cpp
> #include <signal.h>
> #include <sys/time.h>
> #include <iostream>
> #include <cstdlib>
>
>
> using namespace std;
>
> long long int counter = 0;
> struct timeval last_time;
> struct timeval curr_time;
> double dif = 0.0;
> double freq_sum = 0.0;
> double reps = 0.0;
> double freq_min = 99999.0;
> double freq_max = 0.0;
> long long int num_too_low = 0;
>
> void time_check(int data)
> {
>    // work out the frequecy of the SIGALRMs
>    ++counter;
>    if (counter >= 1000)
>    {
>
>        // need to work out time since last 1000 ticks
>        gettimeofday(&curr_time, NULL);
>        dif = ((curr_time.tv_usec + curr_time.tv_sec * 1000000)
>                - (last_time.tv_usec + last_time.tv_sec * 1000000));
>        double freq = (counter / dif)  * 1000000;
>
>        freq_sum = ((freq_sum * reps) + freq) / (reps + 1) ;
>
>        ++reps;
>        cout << "Frequency = " << freq << " reps= " << dif / 1000000 <<
> endl;
>        if (freq_min > freq) freq_min = freq;
>        if (freq_max < freq) freq_max = freq;
>        if (freq < 950)
>            ++num_too_low;
>        last_time = curr_time;
>        counter = 0;
>    }
> }
>
> int main (int argc, char * argv[])
> {
>    cout << "go" /* << "\a \a \a" */ << endl;
>
>    int res;
>    gettimeofday(&last_time, NULL);
>    struct sigaction action;
>
>    struct itimerval timer_value;
>
>    timer_value.it_value.tv_sec = 0;
>    timer_value.it_value.tv_usec = 1;
>    timer_value.it_interval.tv_sec = 0;
>    timer_value.it_interval.tv_usec = 1;
>
>    action.sa_handler = time_check;
>    action.sa_flags = SA_NOMASK;
>    sigemptyset(&action.sa_mask);
>
>    sigaction( SIGALRM, &action, NULL);
>    res = setitimer( ITIMER_REAL, &timer_value, NULL );
>    if (res == -1)
>        cout << "error in setitimer" << endl;
>
>    cout << "Starting CPU Test program" << endl;
>    // loop for a long time
>
>    while (reps < 3000.0)
>    {
>        sleep(1);
>    }
>    cout << "average CPU frequency = " << freq_sum << endl;
>    cout << "reps = " << reps << endl;
>    cout << "Min = " << freq_min << "  Max = " << freq_max << endl;
>    cout << "number of low = " << num_too_low << endl;
>    return 0;
> }
>
> Compiled the above code with    "g++ -o test test.cpp"
> Run the above code with                 "./test"
>
> Observations:
> SUSE Version    AVG. Frequency                  AVG. REPS
> Suse 9.3                999.xxx to 990.xxx                      reps > 1
> (on average)
> Suse 10.2               999.xxx to 998.xxx                      reps (1
> - 1.001)
> Suse 10.3       1000.xxx to 912.xxx                     reps (1 - 1.090)
> Suse 11.1       0 to  324263.xxx                                reps
> (-2e-0.6 upto 0.005112)
>
> Suse 11.1 - Options:
>
> - Turn off ACPI in options when booting with clock=tsc | clock=pit
>
> Observations for suse 11.1 with options acpi=off and clock=tsc |
> clock=pit
>
> SUSE Version    AVG. Frequency                  AVG. REPS
> Suse 11.1               710.xxx to 999.xxx                      reps
> (1.37xx to 1.0002)
>
> Hardware used for Suse 11.1 - HP Pavilion Slimline s3821uk Desktop PC
> (NQ808AA) specifications - HP Home & Home Office products
> http://h10010.www1.hp.com/wwpc/uk/en/ho/WF10a/12454-12454-3329740-64546-
> 64546-3884669.html?jumpid=in_r2515_uk/en/hho/ipg/psc404redirect-ot-xx-xx
> -/chev/
>
> While testing no other application/s were running.
>
> Question:
>
> * Is my c++ code correct?
No. It segfaults on my machine.
BTW, it doesn't measure the clock ticks.
It measures the maximum frequency at which the kernel can fire the
sigalarm, if the machine is fast enough running the time_check.
If the machine is not fast enough, it will print random values (due to
time_check being not reentrant) or segfault.

> * Am I using the correct way to get the clock ticks or is there more
> reliable tchnique avaliable to do this?
Clock ticks do not matter to userspace with newer kernels, since the
high resolution timers can give you a flow of interrupts at 1us
delays.
> * Is that a problem with new Kernel if so is it a known issue ?
No, it is an improvement.
> * Do I need to modify the Kernel to obtain regular and stable clock tick
> at 1000 Hz ?
You can probably disable the high resolution timers, but maybe
changing the way you look at the problem you are solving would be
better. Why are you trying to measure clock ticks? What is the real
problem you want to solve?

> * Do I have to upgrade the Kernel ?
> * Would be great, if pointed to the right direction for solution (e.g.
> another forum) if no solution at hand.
>
> Thanks

Thanks,
Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
