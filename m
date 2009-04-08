Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZDHMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZDHMxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZDHMxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:53:21 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:31415 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZDHMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nZj7JP6JpdgP2WgDhMxHq93lBxr50H2o8PBKjDaD+BwfiT7NwDy7KHSUf0vs0C+IjS
         j+l894NyaRjaYM7HQrD1jiL++myBuZXxGHmmOt0xFpDOkSZcEV96AKInCg2e+DVGJFMt
         dqDBnYj90ZKyY7rmyIs0J1Ox9MXlg7vKhZS54=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 20:53:19 +0800
Message-ID: <cab3445d0904080553k6fc67498s73cb5b7c661ff0b@mail.gmail.com>
Subject: the different effect of system call fork()
From: Sino <szj087@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I don't know whether this is the right place for this email, but I
post it here since it concerns the system call of fork.
here is my fwo source code.

//fork1.cc

#include <iostream>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

using namespace std;

int main(int argc, char **argv)
{
   cout << "main process id: "<<  getpid() << ";  Parent process pid:"
<<getppid() <<endl;
   if (pid_t pid = fork() < 0)
   {
       cout << "Faild to fork child" <<endl;
   }
   else if (pid == 0)
   {
       cout << "first level child procss pid: "<< getpid() << "paraent
pid is : "<<getppid()<<endl;
       if(pid_t spid = fork()  < 0)
       {
           cout<<"failed to create second leve child process"<<endl;
       }
       else if (spid == 0)
       {
           cout<<"second level child process pid is: "<<getpid() <<"
its parent pid is: "<<getppid()<<endl;
          while(1){
            sleep(5);
          }
       }
       else
       {
           _exit(0);
       }
   }else
   {
       if(waitpid(pid,NULL,0) != pid)
       {
           cout << "failed to wait process: " << pid <<endl;
       }

   }
   return 0;
}

Here its result after I run this program
main process id: 4831;  Parent process pid:2931
first level child procss pid: 4831paraent pid is : 2931
second level child process pid is: 4831 its parent pid is: 2931
first level child procss pid: 4832paraent pid is : 4831
second level child process pid is: 4834 its parent pid is: 4832
second level child process pid is: 4832 its parent pid is: 4831
second level child process pid is: 4833 its parent pid is: 4831


When I run ps -ef |grep fork
here is the output
work      4831  2931  0 20:45 pts/2    00:00:00 ./fork
work      4832  4831  0 20:45 pts/2    00:00:00 ./fork
work      4833  4831  0 20:45 pts/2    00:00:00 ./fork
work      4834  4832  0 20:45 pts/2    00:00:00 ./fork

//fork2.cc
#include <iostream>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

using namespace std;

int main(int argc, char **argv)
{
   cout << "main process id: "<<  getpid() << ";  Parent process pid:
" <<getppid() <<endl;
   pid_t pid = fork();
   if (pid  < 0)
   {
       cout << "Faild to fork child" <<endl;
   }
   else if (pid == 0)
   {
       cout << "first level child procss pid: "<< getpid() << ";
paraent pid is : "<<getppid()<<endl;
       pid_t spid = fork();
       if(spid  < 0)
       {
           cout<<"failed to create second leve child process"<<endl;
       }
       else if (spid == 0)
       {
           cout<<"second level child process pid is: "<<getpid() <<";
 its parent pid is: "<<getppid()<<endl;

          while(1){
            sleep(5);
          }
       }
       else
       {
           _exit(0);
       }
   }else
   {
       if(waitpid(pid,NULL,0) != pid)
       {
           cout << "failed to wait process: " << pid <<endl;
       }

   }
   return 0;
}

the result for the same command are here
./fork
main process id: 4867;  Parent process pid:2931
first level child procss pid: 4868paraent pid is : 4867
second level child process pid is: 4869 its parent pid is: 4868

for ps -ef |grep fork

work      4869     1  0 20:50 pts/2    00:00:00 ./fork

The results are very different. For my understanding the results
should be same. but they are not. Why??

Appreciation for your kindly help.

Please let me know where I should post it if this is not the right.

Thanks very much

BRs
Zongjun
