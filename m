Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbXJAPf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbXJAPf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJAPfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:35:50 -0400
Received: from sacred.ru ([62.205.161.221]:50304 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbXJAPft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:35:49 -0400
Message-ID: <470112C7.8000803@openvz.org>
Date: Mon, 01 Oct 2007 19:31:19 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 0/5] A config option to compile out some namespaces code (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 01 Oct 2007 19:33:43 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
* make the NAMESPACES_EXPERIMENTAL selectable even in !EMBEDDED case

There were some questions like "do I need this on my cellphone"
in reply to different namespaces patches. Indeed, the namespaces
are not useful for most of the embedded systems, but the code
creating and releasing them weights a lot.

So I propose to add a config option which will help embedded
people to reduce the vmlinux size. This option simply compiles
out the namespaces cloning and releasing code *only*, but keeps
all the other logic untouched (e.g. the notion of init_ns).

When someone tries to clone some namespace with their support
turned off, he will receive an EINVAL error.

This patchset can save more than 2KB from the vmlinux when
turning the config option "NAMESPACES" to "n":

$ scripts/bloat-o-meter vmlinux-no-ns vmlinux-with-ns 
add/remove: 27/0 grow/shrink: 11/7 up/down: 2477/-340 (2137)
function                                     old     new   delta
copy_pid_ns                                    -     537    +537
copy_user_ns                                   -     181    +181
copy_ipcs                                      -     149    +149
zap_pid_ns_processes                           -     130    +130
copy_utsname                                   -     120    +120
shm_exit_ns                                    -     106    +106
sem_exit_ns                                    -     106    +106
msg_exit_ns                                    -     106    +106
freeary                                        -     100    +100
release_uids                                   -      95     +95
freeque                                        -      92     +92
free_nsproxy                                  48     123     +75
create_new_namespaces                        300     358     +58
free_pid_ns                                    -      56     +56
pid_namespaces_init                            -      48     +48
__sem_init_ns                                  -      45     +45
shm_init_ns                                    -      42     +42
sem_init_ns                                    -      42     +42
msg_init_ns                                    -      42     +42
__shm_init_ns                                  -      38     +38
__msg_init_ns                                  -      31     +31
sysvipc_proc_release                           5      35     +30
proc_kill_sb                                   5      35     +30
free_ipc_ns                                    -      30     +30
do_shm_rmid                                    -      29     +29
proc_set_super                                13      38     +25
shm_release                                   18      39     +21
put_pid                                       75      95     +20
alloc_pid                                    687     706     +19
pid_caches_mutex                               -      16     +16
free_user_ns                                   -      16     +16
sysvipc_proc_open                            100     111     +11
do_shmat                                     778     787      +9
pid_caches_lh                                  -       8      +8
free_uts_ns                                    -       5      +5
pid_ns_cachep                                  -       4      +4
__initcall_pid_namespaces_init6                -       4      +4
do_exit                                     1855    1856      +1
show_stat                                   1665    1661      -4
sys_shmctl                                  1934    1907     -27
msg_init                                      82      47     -35
shm_init                                      92      47     -45
sem_init                                      99      44     -55
sys_msgctl                                  1394    1311     -83
sys_semctl                                  2123    2032     -91

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
