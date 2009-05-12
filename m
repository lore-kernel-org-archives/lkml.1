Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZELFAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZELFAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 01:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZELFAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 01:00:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZELFAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 01:00:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Subject: Re: whole system lock-up on low memory
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4A076A1F.4080300@datenparkplatz.de>
References: <4A076A1F.4080300@datenparkplatz.de>
Message-Id: <20090512135800.D62F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 14:00:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> 
> vanilla linux 2.6.29.3, AMD64, tested on openSUSE 11.1 and Kubuntu 9.04.
> 
> 
> I observe the following behaviour:
> 
> When any user application (non-kernel, non-root) consumes all the
> available system memory, the system freezes completely instead of any
> application being killed by the oom-killer.
> 
> The mouse pointer stalls, and there is a seemingly endless loop of
> hard-disc access, even when no swap space on any harddisc is activated.
> 
> IMO, this is severe, because any application can practically crash the
> system (e.g. in case of a memory-leak), causing data loss in case of
> unsaved data.
> 
> 
> To reproduce this, I've attached a small C++ utility
> (compiles with g++ memory_overcommit.cc -o memory_overcommit.bin) which
> allocates chunks of memory of user defined size.
> 
> On the Ubuntu system, the system freeze can be observed with swap
> enabled on a cryptographic swap partition (dm-crypt; /etc/crypttab).
> With openSUSE the lock-up also occurs with deactivated swap.
> (swapoff -a).
> 
> Tested from a KDE terminal window as regular urser, the
> steps to reproduce are:
> 
> * use cryptographic swap partition or disable swap
>   (maybe also reproducible with normal swap; but apparently not on Suse)
> 
> * compile and invoke the attached code:
>   ./memory_overcommit.bin
> 
> * enter a number (in MiB) of memory that is slightly smaller than the
> available memory and press "enter" key once.
> 
> * enter a smaller number (minimum 1 MiB) and confirm again, do the same
> again,..., successively approaching the limit of available memory with
> smaller chunks.
> 
> * finally, when most of the memory/buffers/cache are used-up, the system
> becomes unresponsive and constant, heavy harddisk-access commences.

umm, I don't reproduce this.
oom-killer kill the reproduce prgram ASAP.

system don't enter unresponsible state.


my test environment:

kernel: 2.6.30-rc4-mmotm
CPU: ia64 x 8
MEM: 8GB



> 
> Sometimes, killing the X-server or shutting down via hotkeys works after
> several minutes of waiting, but this is not consistent.
> 
> 
> I've reported this issue on the Ubuntu bug tracker before:
> https://bugs.launchpad.net/ubuntu/+bug/283420
> 
> but as stated above, I also had the problem on another system.
> 
> 
> I'd be glad if I could help if you need further information.
> 
> 
> Attachement: one file, memory_overcommit.cc
> (also here: http://datenparkplatz.de/DiesUndDas/memory_overcommit.cc)
> ---
> #include <cassert>
> #include <cerrno>
> #include <clocale>
> #include <cstdio>
> #include <cstdlib>
> #include <cstring>
> #include <limits>
> 
> using std::exit;
> using std::numeric_limits;
> using std::printf;
> using std::size_t;
> using std::strlen;
> 
> void read_answer(char* buffer, size_t buffer_size)
> {
>         assert(buffer_size > 1);
> 
>         char const* ret = std::fgets(buffer, buffer_size, stdin);
>         if(ret == 0)
>         {
>                 printf("\nSorry, there was an error while reading the
> answer. This program will now terminate.\n");
> 
>                 exit(EXIT_FAILURE);
> 
>         }
> 
>         else if(strlen(buffer) == buffer_size - 1 && buffer[buffer_size
> - 2] != '\n')
>         {
> 
>                 printf("Sorry, you answer is too long (possibly out of
> range). This program will now terminate.\n");
> 
>                 exit(EXIT_FAILURE);
> 
>         }
> 
> }
> 
> 
> size_t determine_size(char const* s)
> {
>         assert(strlen(s) > 0);
> 
>         char* endptr = 0;
>         errno = 0;
>         unsigned long v = std::strtoul(s, &endptr, 10);
>         if(strlen(s) == 1 || endptr != s + strlen(s) - 1)
>         {
>                 printf("\nSorry, your answer does not appear to be
> valid. This program will now terminate.\n");
> 
>                 exit(EXIT_FAILURE);
> 
>         }
> 
>         else if((v == numeric_limits<unsigned long>::max() && errno ==
> ERANGE) || v == 0
>                 || numeric_limits<unsigned long>::max() / (1024 * 1024)
> < v)
>         {
> 
>                 printf("\nSorry, that value is out of range. This
> program will now terminate.\n");
>                 exit(EXIT_FAILURE);
> 
>         }
> 
>         v *= 1024 * 1024;
> 
> 
>         assert(numeric_limits<size_t>::is_specialized);
>         if(v > numeric_limits<size_t>::max() )
>         {
>                 printf("\nSorry, that value is out of range. This
> program will now terminate.\n");
>                 exit(EXIT_FAILURE);
> 
>         }
> 
> 
>         return v;
> }
> 
> bool inquire_repeat(size_t& v)
> {
>         printf("\nShould a new allocation be made? You can enter:\n"
>                         "==> \"No\" to quit,\n"
>                         "==> Any Number of MiB to change the chunk size
> and continue, or\n"
>                         "==> Hit return to continue with last chunk
> size.\n\nYour answer: ");
> 
>         char answer[20];
>         read_answer(answer, sizeof(answer) );
>         if(std::strcmp(answer, "\n") == 0) {
>                 return true;
>         }
>         else if(std::strcmp(answer, "No\n") == 0) {
>                 return false;
>         }
> 
>         v = determine_size(answer);
>         return true;
> }
> 
> 
> int main() {
>         #ifdef _POSIX_C_SOURCE
>         std::setlocale(LC_ALL, ""); // Prepare thousands grouping in output.
>         #endif
> 
>         printf("\n\nThis program allows to repeatedly allocate chunks of
> memory of user-specified size. "
>                "\nAfter each allocation the user can choose to repeat or
> to quit the program.\n\nFirst, please enter now "
> 
>                "the amount of memory in MiB (1024 * 1024 bytes) \nto
> allocate in each round: ");
>         char answer[20];
> 
>         read_answer(answer, sizeof(answer) );
> 
> 
>         size_t alloc_size = determine_size(answer);
> 
>         size_t total = 0;
>         do {
>                 printf("\n   >>> Starting to allocate chunk...\n");
>                 std::fflush(stdout);
>                 void* p = std::malloc(alloc_size);
>                 if(!p) {
>                         printf("\n   > The last memory allocation failed."
>                                "\n   > This means the system reported
> the out-of-memory condition orderly."
>                                "\nThis program will now terminate.\n");
> 
>                         exit(0);
> 
>                 }
> 
>                 std::memset(p, 0, alloc_size);
> 
>                 printf("   >>> A chunk was just allocated! <<<\n");
>                 if(numeric_limits<size_t>::max() - total >= alloc_size)
>                 {
>                         total += alloc_size;
> 
>                         #ifdef _POSIX_C_SOURCE
>                         char const* fmt_string = "   The total number of
> bytes allocated is now %'zu.\n";
>                         #else
>                         char const* fmt_string = "   The total number of
> bytes allocated is now %zu.\n";
>                         #endif
> 
>                         printf(fmt_string, total);
>                 }
>                 else {
>                         #ifdef _POSIX_C_SOURCE
>                         char const* fmt_string = "   More than %'zu
> bytes have been allocated in total by now.\n";
>                         #else
>                         char const* fmt_string = "   More than %zu bytes
> have been allocated in total by now.\n";
>                         #endif
> 
>                         printf(fmt_string, total);
>                         total = numeric_limits<size_t>::max();
>                 }
>         } while(inquire_repeat(alloc_size) );
> 
>         printf("\nQuit was requested. This program will now terminate.\n");
> }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



