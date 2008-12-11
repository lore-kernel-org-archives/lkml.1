Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYLKBcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYLKBcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYLKBcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:32:09 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:53472 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbYLKBcI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:32:08 -0500
Message-ID: <11317562.1228959126677.JavaMail.ngmail@webmail11.arcor-online.net>
Date: Thu, 11 Dec 2008 02:32:06 +0100 (CET)
From: xcomp@arcor.de
To: linux-kernel@vger.kernel.org
Subject: Problem with old context in signal handler function
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 207.105.30.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
I want to switch between user contexts using a signal handler (something like a preemptive scheduler for userlevel threads). I've found several sources, which say that it's not a good idea to use setcontext or swapcontext in a signal handler. Nevertheless there also exists at least one sample code of such an preemptive scheduler, which seems to work well, at least on my machine (Ubuntu 8.04 with linux kernel 2.6.24-22): www.seas.upenn.edu/~cse381/context_demo.c

// [...]
static ucontext_t thread_context;
static ucontext_t scheduler_context;

int thread_finished;
int i;

static void simple_function(void) {
	// do nothing but counting
	for (i = 0; i < 1000000000; ++i) { }

	if (i == 1000000000) {
		printf("\n[Thread Function]\t1st counting worked fine...");
	} else {
		printf("\n[Thread Function]\tError: Counting didn't finished (%d)...", i);
	}

	thread_finished = 1;
}

static void other_function() {
	// thread_finished is a global variable, which is set to 1, if the thread function is finished
	while(thread_finished != 1) { swapcontext(&scheduler_context, &thread_context); }
}

static void signal_handler_function(int sig_nr, siginfo_t* info, void *old_context) {
	if (sig_nr == SIGPROF) {
		// saves the thread context
		thread_context = *((ucontext_t*) context);

		// swaps back to scheduler context
		setcontext(&scheduler_context);
	}
}
// [...]

I ran into the following problem which belongs to the code above. I interrupted simple_function several times by using a ITimer. But the for-loop doesn't finish successfully everytime. Often the if condition is false. But it does not cancel after the first signal is raised. I've found out that using the third parameter old_context for storing the old context is the reason. But I don't know why. So I thought there might be a problem in the kernel. Am I right? I was afraid to post the whole code, so I hope that this code snippet is enough.
I would appreciate if someone can give me a comment whether this strange behaviour is because of a wrong thinking of mine or because of a error in the kernel which needs to be fixed.

Thanks a lot!
Matthias


Jetzt komfortabel bei Arcor-Digital TV einsteigen: Mehr Happy Ends, mehr Herzschmerz, mehr Fernsehen! Erleben Sie 50 digitale TV Programme und optional 60 Pay TV Sender, einen elektronischen Programmführer mit Movie Star Bewertungen von TV Movie. Außerdem, aktuelle Filmhits und spannende Dokus in der Arcor-Videothek. Infos unter www.arcor.de/tv
