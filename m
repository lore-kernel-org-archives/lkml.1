Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0CJIGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:06:07 -0500
Received: from web7603.mail.in.yahoo.com ([202.86.4.22]:23738 "HELO
	web7603.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754285Ab0CJIFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:05:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pREJTLlEBsTLCJPlm6Yyc0hBbcb8S2Rs2eMjmn1BRFTSbyMaAuQVZUGA4AhnvjZx1D7K5Jt0U1fRsHTWkVcrK6pRj2wSdqAg9pXhxzY/qrzbMl3F2raW4wwZMLm5hKWx987wpBEcPng1u4stHiR7w5a84raxuwB5IjrCId+2hwI=;
Message-ID: <460422.78917.qm@web7603.mail.in.yahoo.com>
X-YMail-OSG: c6EpgzIVM1mjeOGNslB83_jU.P3EqjDNX7T.hJPzlD08Nm8
 bkfl4_E5GVKf6jZV.IXFWhS4e1t5EIO0QcPPS8GE__K6nR8ebH6CBv24P_97
 OKfTWYP1UCcjZAPqlkkI5syVysIcOwkGBeqaOXWozjMEkqIxaSyMRqqMxEEZ
 yt44TY6cO_i9fF1qWIzauSRMf4x1eExbBiMt_vL7yeKhuYuHB2D0RyuvMlrU
 3oJq4FwTP_oyOeykV3AwFUfXJh0ES8SGB4bZuSECL0BesNE7Z2XIFdPLOh.K
 6rPinFjf.3F0E82wHaTejEr8p7uCodqaNAyk-
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Wed, 10 Mar 2010 13:29:11 +0530 (IST)
From: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Subject: BUG: Is it a bug in Linux time() function or Linux OS calls?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I wrote a small program, that creates files at an interval of 1 minute. But the time at which the file is created and last written and the last modification time of the file as shown by ls command differs by 1 second. The code and the output is presented below. please let me know where could be the bug?

	root@new:/home/srinivas# cat b.c 
	#include <time.h> 
	#include <stdio.h> 
	#include <sys/stat.h> 
	#include <dirent.h> 
	#include <fcntl.h> 
	int main () 
	{ 
	    int fd; 
	    int i=0; 
	    time_t initial_time = time(NULL); 
	    time_t interval = 60; 
	    time_t curr_time = time(NULL); 

	    fd=open ("test1.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666); 
	    write(fd,"abcd1",5); 
	    while(1) 
	    { 
		curr_time = time(NULL); 
		if(curr_time >= initial_time) 
		{ 
		    if(i==0) 
		    { 
			close(fd); 
			printf("\ntime before test2.txt fileopen= %d\n", time(NULL)); 
			fd=open ("test2.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666); 
			write(fd,"abcd2",5); 
			printf("time after test2.txt filewrite= %d\n", time(NULL)); 
			system("ls -l --time-style=+%s test2.txt"); 
			initial_time += interval; 
			i=1; 
		    } 
		    else 
		    { 
			close(fd); 
			printf("\ntime before test1.txt fileopen= %d\n", time(NULL)); 
			fd=open ("test1.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666); 
			write(fd,"abcd1",5); 
			printf("time after test1.txt filewrite= %d\n", time(NULL)); 
			system("ls -l --time-style=+%s test1.txt"); 
			initial_time += interval; 
			i=0; 
		    } 
		} 
		usleep(1000); 
	    } 
	    return 0; 
	} 
	root@new:/home/srinivas# gcc b.c 
	root@new:/home/srinivas# ./a.out 

	time before test2.txt fileopen= 1268203133 
	time after test2.txt filewrite= 1268203133 
	-rw-r--r-- 1 root root 5 1268203133 test2.txt 

	time before test1.txt fileopen= 1268203193 
	time after test1.txt filewrite= 1268203193 
	-rw-r--r-- 1 root root 5 1268203192 test1.txt 

	time before test2.txt fileopen= 1268203253 
	time after test2.txt filewrite= 1268203253 
	-rw-r--r-- 1 root root 5 1268203252 test2.txt 

	time before test1.txt fileopen= 1268203313 
	time after test1.txt filewrite= 1268203313 
	-rw-r--r-- 1 root root 5 1268203312 test1.txt 

	time before test2.txt fileopen= 1268203373 
	time after test2.txt filewrite= 1268203373 
	-rw-r--r-- 1 root root 5 1268203372 test2.txt 

	root@new:/home/srinivas# ls -ltr --time-style=+%s 
	total 40 
	-rwxrwxrwx  1 root     root      1095 1268202457 b.c 
	-rwxr-xr-x  1 root     root     10300 1268202459 a.out 
	-rw-r--r--  1 root     root         5 1268203312 test1.txt 
	-rw-r--r--  1 root     root         5 1268203372 test2.txt 
	root@new:/home/srinivas# 


Some system info:
===========
Linux new 2.6.24-19-server #1 SMP Wed Jun 18 14:44:47 UTC 2008 x86_64 GNU/Linux
Gnu C                  4.2.4
Linux C Library        2.7
binutils               2.18.0.20080103
util-linux             2.13.1
Console-tools          0.2.3
Sh-utils               6.10
===========


With best regards,
 
Yours sincerely,
Srinivas Nayak
 
My Home page: http://www.mathmeth.com/sn/
My Blog: http://srinivas-nayak.blogspot.com


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
